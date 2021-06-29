FROM public.ecr.aws/x2q3v6u1/debenstack-lychee-base:latest

# Install Lychee
RUN useradd --create-home --no-log-init --shell /bin/bash lycheeuser
RUN usermod -a -G www-data lycheeuser

# =========================================
# Lychee Version
# =========================================
ENV LYCHEE_VERSION v4.0.8

WORKDIR /var/www
RUN wget -O lychee.zip https://github.com/LycheeOrg/Lychee/releases/download/${LYCHEE_VERSION}/Lychee.zip && \
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

