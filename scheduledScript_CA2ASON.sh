#! /bin/sh

chmod 000 /var/www/html/Intranet/
sudo cp -r -u /var/www/html/Intranet/* /var/www/html/Live
chmod 777 /var/www/html/Intranet/

