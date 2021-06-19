
echo "Downloading Latest Contents"
KEY=`aws s3 ls pt-debenstack-contents-backups-us-east-1/lychee --recursive | sort | tail -n 1 | awk '{print $4}'`
echo "Downloading $KEY"
aws s3 cp s3://pt-debenstack-contents-backups-us-east-1/$KEY /tmp/content.zip --only-show-errors
echo "Unpacking Contents"
unzip /tmp/content.zip -d /var/www/Lychee/public/uploads/
echo "Removing ZIP File"
rm -f /tmp/content.zip

echo "Starting FPM Service"
service php7.4-fpm start
echo "Starting And Hanging Off of NGINX"
nginx -g "daemon off;"