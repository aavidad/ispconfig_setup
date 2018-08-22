#---------------------------------------------------------------------
# Function: InstallWebServer Debian 8
#    Install and configure Apache2, php + modules
#---------------------------------------------------------------------
InstallWebServer() {
  
  if [ "$CFG_WEBSERVER" == "apache" ]; then
	echo -n "Instalando Apache, phpmyadmin y sus modulos... "
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
	echo "dbconfig-common dbconfig-common/dbconfig-install boolean true" | debconf-set-selections
	apt-get -yqq install apache2 apache2-doc apache2-utils libapache2-mod-php php7.2 php7.2-common php7.2-gd php7.2-mysql php7.2-imap php7.2-cli php7.2-cgi libapache2-mod-fcgid apache2-suexec-pristine php-pear mcrypt  imagemagick libruby libapache2-mod-python > /dev/null 2>&1  
	echo -e "[${green}HECHO${NC}]\n"
	echo -n "Instalando modulos de PHP... "
	apt-get -yqq   php7.2-curl php7.2-intl php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-tidy php7.2-xmlrpc php7.2-xsl memcached php-memcache php-imagick php-gettext php7.2-zip php7.2-mbstring php-soap php7.2-soap > /dev/null 2>&1
	echo -e "[${green}HECHO${NC}]\n"
		
  if [ "$CFG_PHPMYADMIN" == "yes" ]; then
	echo -n "Instalando phpMyAdmin... "
	apt-get -y install phpmyadmin
	echo "Arreglando bug de phpmyadmin y php7..."
	sed -i "s/(count($analyzed_sql_results['select_expr'] == 1)/((count($analyzed_sql_results['select_expr']) == 1)/g"  /usr/share/phpmyadmin/libraries/sql.lib.php
	echo -e "[${green}HECHO${NC}]\n"
  fi
	
  if [ "$CFG_XCACHE" == "yes" ]; then
	echo -n "Installing XCache... "
	apt-get -yqq install php7-xcache > /dev/null 2>&1
	echo -e "[${green}HECHO${NC}]\n"
  fi
	
	echo -n "Activating Apache2 Modules... "
	a2enmod suexec > /dev/null 2>&1
	a2enmod rewrite > /dev/null 2>&1
	a2enmod ssl > /dev/null 2>&1
	a2enmod actions > /dev/null 2>&1
	a2enmod include > /dev/null 2>&1
	a2enmod dav_fs > /dev/null 2>&1
	a2enmod dav > /dev/null 2>&1
	a2enmod auth_digest > /dev/null 2>&1
	a2enmod fastcgi > /dev/null 2>&1
	a2enmod alias > /dev/null 2>&1
	a2enmod fcgid > /dev/null 2>&1
	service apache2 restart > /dev/null 2>&1
	echo -e "[${green}HECHO${NC}]\n"
  
  else
	
	echo -n "Instalando NGINX y Módulos... "
	service apache2 stop > /dev/null 2>&1
	update-rc.d -f apache2 remove > /dev/null 2>&1
	apt-get -yqq install nginx > /dev/null 2>&1
	service nginx start 
	apt-get -yqq install php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap php7.0-cli php7.0-cgi php-pear php-auth php7.0-mcrypt mcrypt imagemagick libruby php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring php7.0-fpm php7.0-opcache php-apcu > /dev/null 2>&1
	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
	sed -i "s/;date.timezone =/date.timezone=\"Europe\/Rome\"/" /etc/php/7.0/fpm/php.ini
	service php7-fpm reload
	apt-get -yqq install fcgiwrap
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
        # - DISABLED DUE TO A BUG IN DBCONFIG - echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
    	echo "dbconfig-common dbconfig-common/dbconfig-install boolean false" | debconf-set-selections
		apt-get -y install phpmyadmin
    	echo "With nginx phpmyadmin is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/phpmyadmin or http://IP_ADDRESS:8081/phpmyadmin"
  fi
  echo -e "[${green}DONE${NC}]\n"
}
