#
# Cookbook Name:: webserver-chef
# Recipe:: _redhat
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
# 
# Redhat only bits
#

# enable apache access to sendmail on rhel.
selinuxCheck = `/usr/sbin/getenforce`
script "selinux_http_sendmail" do
  interpreter "bash"
  code "/usr/sbin/setsebool -P httpd_can_sendmail 1"
  not_if "getsebool httpd_can_sendmail |egrep -q \" on\"$"
end
script "httpd_can_network_connect_db" do
  interpreter "bash"
  code "/usr/sbin/setsebool -P httpd_can_network_connect_db 1"
  not_if "getsebool httpd_can_network_connect_db |egrep -q \" on\"$"
end
script "httpd_can_network_memcache" do
  interpreter "bash"
  code "/usr/sbin/setsebool -P httpd_can_network_memcache 1"
  not_if "getsebool httpd_can_network_memcache |egrep -q \" on\"$"
end

cookbook_file "newrelic-daemon.pp" do
  path "/root/newrelic-daemon.pp"
  action :create_if_missing
end

selinux = `/usr/sbin/semodule -l`
execute "selinux_newrelic" do
  command "/usr/sbin/semodule -i /root/newrelic-daemon.pp"
  action :run
  not_if {selinux.include? "newrelic-daemon"}
end

execute "selinux_folder" do
  command "chcon -R -t httpd_sys_content_t /media"
  action :run
end


apache_site "default" do
  enable true
end

case node['php']['version']
when "php55"
  php_pear 'apcu' do
    action :install
    preferred_state "beta"
    notifies :restart, "service[apache2]", :delayed
  end
end

template "#{node['php']['ext_conf_dir']}/apc.ini" do
  source "apcu.ini.erb"
  owner  node['apache']['user']
  group  node['apache']['group']
  mode   "0444"
  variables({
    :shm_size => node['php']['apc']['shm_size'],
    :enable_cli => 0,
    :enable => node['php']['apc']['enable']
  })
  notifies :restart, "service[apache2]", :delayed
  only_if {File.exists?("#{node['php']['ext_dir']}/apcu.so")}
end
