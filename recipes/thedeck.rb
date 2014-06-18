#
# Cookbook Name:: webserver-chef
# Recipe:: theDeck
#
# Copyright 2014, National Theatre
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential::default"
include_recipe "webserver-chef::default"

remote_file "/tmp/#{node['php']['geos']['version'}.tar.bz2" do
  source "http://download.osgeo.org/geos/#{node['php']['geos']['version'}.tar.bz2"
  mode "0644"
  not_if { ::File.exists?(node['php']['ext_dir'] . '/geos.so') }
end

execute "install-geoPHP" do
  cwd "/tmp"
  command <<-EOF
    tar jxf #{node['php']['geos']['version'}.tar.bz2
    cd #{node['php']['geos']['version'}
    ./configure --enable-php && make clean && make
    make install
    ldconfig
    cd ..
    rm -yr #{node['php']['geos']['version'}
    rm -y #{node['php']['geos']['version'}.tar.bz2
  EOF
  not_if { ::File.exists?(node['php']['ext_dir'] . '/geos.so') }
end

cookbook_file "geos.ini" do
  path "#{node['php']['ext_conf_dir']}/geos.ini"
  action :create_if_missing
end