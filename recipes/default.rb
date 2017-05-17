#
# Cookbook Name:: pm2
# Recipe:: default
#
# Copyright 2015, Mindera
#

# Constants
NODE_VERSION = node['pm2']['node_version']

# Install node
#javascript_runtime 'node' do
#  version NODE_VERSION
#end

# Install node packages
%w(pm2).each do |pkg|
  nodejs_npm pkg do
    version node['pm2']["#{pkg}_version"] unless node['pm2']["#{pkg}_version"].nil?
  end
end

# Link executable into system path
%w(node pm2 npm).each do |exe|
  link "/usr/bin/#{exe}" do
    to "/usr/local/nodejs-binary-#{node['pm2']['node_version']}/bin/#{exe}"
  end
end
