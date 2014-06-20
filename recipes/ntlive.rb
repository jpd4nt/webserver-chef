#
# Cookbook Name:: webserver-chef
# Recipe:: ntlive
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential::default"

# install the mongo pecl driver
php_pear "mongo" do
  action :install
  notifies :restart, "service[apache2]", :delayed
end

case node['platform_family']
when "rhel", "fedora", "centos"
  %w{ GeoIP-devel }.each do |pkg|
    package pkg do
      action :install
    end
  end
end
# install the geoip pecl for ip lookup
php_pear "geoip" do
  action :install
  notifies :restart, "service[apache2]", :delayed
end

remote_file "/usr/share/GeoIP/GeoLiteCity.dat.gz" do
  source "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
  mode "0644"
  not_if { ::File.exists?('/usr/share/GeoIP/GeoIPCity.dat') }
end

execute "install-GeoLiteCity" do
  cwd "/usr/share/GeoIP"
  command <<-EOF
    gunzip GeoLiteCity.dat.gz
    mv GeoLiteCity.dat GeoIPCity.dat
  EOF
  not_if { ::File.exists?('/usr/share/GeoIP/GeoIPCity.dat') }
end
