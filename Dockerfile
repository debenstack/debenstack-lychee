FROM debian:10

RUN apt-get update -y && apt-get upgrade -y && apt-get install apt-utils unzip build-essential -y

# Install PHP 7.4
RUN apt-get update && \
    apt-get install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https php-redis
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list
RUN apt-get update && \
    apt-get install -y php7.4 php7.4-cli php7.4-common php7.4-fpm && \
    apt-get install -y imagemagick jq mc ffmpeg ufraw ufraw-batch libimage-exiftool-perl re2c openssl && \
    apt-get install -y php7.4-curl php7.4-exif php7.4-gd php7.4-imagick php7.4-mysqli php7.4-mysqlnd php7.4-mysql php7.4-phar php7.4-zip php7.4-redis php7.4-dom php7.4-bcmath php7.4-ctype php7.4-fileinfo php7.4-mbstring php7.4-pdo php7.4-tokenizer php7.4-xml php7.4-redis
# Install Composer
RUN apt-get install -y composer

# Install Nginx
RUN apt-get install nginx -y

# Install AWS CLI
RUN apt-get install groff less -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    ln -s /usr/local/bin/aws /usr/bin/aws

# Install Lychee
RUN useradd --create-home --no-log-init --shell /bin/bash lycheeuser
RUN usermod -a -G www-data lycheeuser

WORKDIR /var/www
RUN wget -O lychee.zip https://github.com/LycheeOrg/Lychee/releases/download/v4.0.8/Lychee.zip && \
    mkdir -p ./Lychee/bootstrap/cache && \
    unzip lychee.zip && rm lychee.zip && rm ./Lychee/.env.example && \
    chown -R www-data:www-data ./Lychee && \
    chmod 774 -R ./Lychee/vendor && \
    chmod 774 -R ./Lychee/storage && \
    chmod 774 -R ./Lychee/bootstrap/cache && \
    chmod 774 -R ./Lychee/public/dist && \
    chmod 774 -R ./Lychee/public/uploads && \
    chmod 774 -R ./Lychee/public/sym

USER lycheeuser
RUN cd ./Lychee && composer install --no-dev

WORKDIR /workspace
USER root
#COPY ./content/uploads/ /var/www/Lychee/public/uploads/
COPY ./content/nginx.conf /etc/nginx/nginx.conf
COPY ./content/startup.sh /startup.sh
ENTRYPOINT ["sh", "/startup.sh"]
