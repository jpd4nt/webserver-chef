#
# Cookbook Name:: webserver-chef
# Recipe:: mongodb_client
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
# 

# install the xhprof pecl
php_pear "mongo" do
  action :install
  notifies :restart, "service[apache2]", :delayed
end

# Does not work for some reason
#php_pear "mongo" do
#  action :upgrade
#  version node['php']['mongo']['version']
#  notifies :restart, "service[apache2]", :delayed
#end

# This means that the socket could not be opened due to permissions issues.
# On Red Hat variants, this can be caused by a default setting that does not
# allow Apache to create network connections.
case node['platform_family']
when "rhel"
  selinux = `/usr/sbin/getsebool httpd_can_network_connect`
  execute "selinx_http" do
    command "/usr/sbin/setsebool -P httpd_can_network_connect 1"
    action :run
    notifies :restart, "service[apache2]", :delayed
    # Don't ask me why its 8, ask ruby why its 8.
    not_if {selinux.count('on') == 8 }
  end
end