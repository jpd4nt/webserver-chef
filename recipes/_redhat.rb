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
selinux = `/usr/sbin/getsebool httpd_can_sendmail`
execute "selinx_http" do
  command "/usr/sbin/setsebool -P httpd_can_sendmail 1"
  action :run
  # Don't ask me why its 4, ask ruby why its 4.
  not_if {selinux.count('on') == 4}
end

cookbook_file "newrelic-daemon.pp" do
  path "/root/newrelic-daemon.pp"
  action :create_if_missing
end

selinux = `/usr/sbin/semodule -l`
execute "selinux_newrelic" do
  command "/usr/sbin/semodule -i /root/newrelic-daemon.pp"
  action :run
  # Don't ask me why its 4, ask ruby why its 4.
  not_if {selinux.include? "newrelic-daemon"}
end