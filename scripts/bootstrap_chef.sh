#!/bin/bash
#set hostname
sudo hostname 10.100.198.200

# install chef-solo
curl -L https://www.chef.io/chef/install.sh | sudo bash
# create required bootstrap dirs/files
sudo mkdir -p /var/chef/cache /var/chef/cookbooks
# pull down this chef-server cookbook
wget -qO- https://supermarket.chef.io/cookbooks/chef-server/download | sudo tar xvzC /var/chef/cookbooks
# pull down dependency cookbooks
for dep in chef-ingredient
do
  wget -qO- https://supermarket.chef.io/cookbooks/${dep}/download | sudo tar xvzC /var/chef/cookbooks
done
# GO GO GO!!!
sudo chef-solo -o 'recipe[chef-server::default]'

#creates an organization
sudo chef-server-ctl org-create dou digitalonus -f dou.pem

#creates an admin user
sudo chef-server-ctl user-create admin Gonzalo Lopez gmlp.24a@gmail.com 123456 -f admin.pem -o dou

#installs chef-manage plugin
sudo chef-server-ctl install chef-manage 
sudo chef-server-ctl reconfigure 
sudo chef-manage-ctl reconfigure --accept-license

#cp certs
sudo cp /var/opt/opscode/nginx/ca/10.100.198.200.crt /home/vagrant
sudo chown -R vagrant:vagrant /home/vagrant 


