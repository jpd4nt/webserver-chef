#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

define :webserver_chef_vhost, :template => "vhost.conf.erb", :enable => true do
  
  application_name = params[:name]

  include_recipe "apache2"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_deflate"
  include_recipe "apache2::mod_headers"
  
  template "#{node['apache']['dir']}/sites-available/#{application_name}.conf" do
    source params[:template]
    owner "root"
    group node['apache']['root_group']
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node['apache']['dir']}/sites-enabled/#{application_name}.conf")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end
  
  apache_site "#{params[:name]}.conf" do
    enable params[:enable]
  end
end

define :drupal_chef_vhost, :template => "drupal.conf.erb", :enable => true do
  
  application_name = params[:name]

  include_recipe "apache2"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_deflate"
  include_recipe "apache2::mod_headers"
  
  template "#{node['apache']['dir']}/sites-available/#{application_name}.conf" do
    source params[:template]
    owner "root"
    group node['apache']['root_group']
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    if !params[:proxy].present?
      params[:proxy] = false
    end
    if !params[:admin_block].present?
      params[:admin_block] = []
    end
    if !params[:user_block].present?
      params[:user_block] = []
    end
    variables(
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node['apache']['dir']}/sites-enabled/#{application_name}.conf")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end
  
  apache_site "#{params[:name]}.conf" do
    enable params[:enable]
  end
end