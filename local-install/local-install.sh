#! /bin/bash

set -e

DEFAULT_PORT=29990
DEFAULT_SERVICENAME="mydocs"
read -p "Enter service name[default $DEFAULT_SERVICENAME]" servicename
read -p "Enter path where you want your documentation source project: " vpath
read -p "Enter PORT where you want to server runs[default $DEFAULT_PORT] : " port
servicename=${servicename:-$DEFAULT_SERVICENAME}
port=${port:-$DEFAULT_PORT}
servicetemplatepath=mydocs.service
servicefinalpath="/etc/systemd/system/$servicename.service"
url=http://localhost:$port
echo "documentation project source will be in $vpath"
echo "service name will be  $servicename"
echo "server port will be  $port"
read -p "ENTER to continue, else press clt C" vcontinue

echo "downloading project in $vpath"
git clone https://github.com/SantiagoAndre/SRE-Meetings-Directory/  $vpath 
# sudo rm -r $vpath/.git/
echo -e "PORT=$port\nSERVICENAME=$servicename" >> $vpath/.env
echo "temp downloading service template in $servicetemplatepath"
wget https://raw.githubusercontent.com/SantiagoAndre/SRE-Meetings-Directory/local-install/local-install/mydocs.service -O $servicetemplatepath

echo "installing service  in $servicetemplatepath"
z="{sub(\"{vpath}\",\"$vpath\")}1"
sudo awk $z $servicetemplatepath > $servicefinalpath
echo "deleting temp template"
rm $servicetemplatepath

echo "starting service $servicename"
sudo systemctl start "$servicename.service" 
echo "enabling service $servicename"
sudo systemctl enable "$servicename.service"
echo "documentation server installed"
if which xdg-open > /dev/null
then
  xdg-open $url
elif which gnome-open > /dev/null
then
  gnome-open $url 
fi
echo "open $url to see your new documentation server"
echo "run the next commands to interact with your service $servicename"
echo "sudo systemctl status $servicename.service"
echo "sudo systemctl start $servicename.service"
echo "sudo systemctl enable $servicename.service"
echo "sudo systemctl disable $servicename.service"

