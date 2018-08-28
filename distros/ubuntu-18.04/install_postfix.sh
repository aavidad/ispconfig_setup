#---------------------------------------------------------------------
# Function: Install Postfix
#    Install and configure postfix
#---------------------------------------------------------------------
InstallPostfix() {
  echo "Deshabilitando Sendmail... "
  if [ -f /etc/init.d/sendmail ]; then
	service sendmail stop > /dev/null 2>&1
	update-rc.d -f sendmail remove > /dev/null 2>&1
	debconf-apt-progress -- apt-get -y remove sendmail 
  fi
  
  echo -n "Instalando Postfix... "
  echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
  echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections
  debconf-apt-progress -- apt-get -yqq install postfix postfix-mysql postfix-doc getmail4 
  sed -i "s/#submission inet n       -       -       -       -       smtpd/submission inet n       -       -       -       -       smtpd/" /etc/postfix/master.cf
  sed -i "s/#  -o syslog_name=postfix\/submission/  -o syslog_name=postfix\/submission/" /etc/postfix/master.cf
  sed -i "s/#  -o smtpd_tls_security_level=encrypt/  -o smtpd_tls_security_level=encrypt/" /etc/postfix/master.cf
  sed -i "s/#  -o smtpd_sasl_auth_enable=yes/  -o smtpd_sasl_auth_enable=yes\\`echo -e '\n\r'`  -o smtpd_client_restrictions=permit_sasl_authenticated,reject/" /etc/postfix/master.cf
  sed -i "s/#smtps     inet  n       -       -       -       -       smtpd/smtps     inet  n       -       -       -       -       smtpd/" /etc/postfix/master.cf
  sed -i "s/#  -o syslog_name=postfix\/smtps/  -o syslog_name=postfix\/smtps/" /etc/postfix/master.cf
  sed -i "s/#  -o smtpd_tls_wrappermode=yes/  -o smtpd_tls_wrappermode=yes/" /etc/postfix/master.cf
  sed -i "s/#  -o smtpd_sasl_auth_enable=yes/  -o smtpd_sasl_auth_enable=yes\\`echo -e '\n\r'`  -o smtpd_client_restrictions=permit_sasl_authenticated,reject/" /etc/postfix/master.cf
  service postfix restart > /dev/null 2>&1
  echo -e "[${green}HECHO${NC}]\n"
}
