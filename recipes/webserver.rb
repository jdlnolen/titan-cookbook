#
# Cookbook Name:: titan
# Recipe:: webserver
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

group node[:titan][:group]

user node[:titan][:user] do
  group node[:titan][:group]
  system true
  shell "/bin/bash"
end

include_recipe "apache2"

# disable default site
apache_site "000-default" do
  enable false
end

# create apache config
template "#{node[:apache][:dir]}/sites-available/#{node[:titan][:config]}" do
  source "apache2.conf.erb"
  notifies :restart, 'service[apache2]'
end

# create document root
directory "#{node[:titan][:document_root]}" do
  action :create
  recursive true
end

# write site
cookbook_file "#{node[:titan][:document_root]}/index.html" do
  mode "0644" 
end

# enable titan
apache_site "#{node[:titan][:config]}" do
  enable true
end