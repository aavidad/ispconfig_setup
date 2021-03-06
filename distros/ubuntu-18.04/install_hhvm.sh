#---------------------------------------------------------------------
# Function: InstallHHVM
#    Install HHVM
#---------------------------------------------------------------------
InstallHHVM() {
  echo -n "Instalando HHVM...) "
  # installs add-apt-repository
	debconf-apt-progress -- apt-get install software-properties-common
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
	add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
	debconf-apt-progress -- apt-get update
	debconf-apt-progress -- apt-get install hhvm
 echo -e "[${green}HECHO${NC}]\n"
}
