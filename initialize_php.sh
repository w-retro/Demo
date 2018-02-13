#install mongodb extension
pecl install mongodb

#setup php with mongodb extension
echo "extension=mongodb.so" > /etc/php/7.1/fpm/conf.d/20-mongodb.ini
echo "extension=mongodb.so" > /etc/php/7.1/cli/conf.d/20-mongodb.ini
echo "extension=mongodb.so" > /etc/php/7.1/mods-available/mongodb.ini

service php7.1-fpm stop && service php7.1-fpm start

#setup libraries
composer update
composer dump-autoload --optimize

#add this bootstrap
AUTO_PREPEND_STRING='fastcgi_param PHP_VALUE "auto_prepend_file=/server/http/bootstrap/php_prepend.php";'
if grep -qF "$AUTO_PREPEND_STRING" /etc/nginx/fastcgi_params; then
    echo "php prepend file already set"
else
    echo "$AUTO_PREPEND_STRING" >> /etc/nginx/fastcgi_params
    #stop it and start it manually because using restart option sometimes freezes
    service nginx stop && service nginx start
fi
