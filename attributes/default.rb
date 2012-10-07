#
# Cookbook Name:: webserver-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

default['php']['apc']['enable']   = '1'
default['php']['apc']['shm_size'] = '32M'
default['php']['apc']['stat']     = '1'
default['php']['apc']['username'] = 'apc'
default['php']['apc']['password'] = 'password1'