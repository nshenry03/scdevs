#
# Cookbook Name:: scdevs
# Recipe:: default
#
# Copyright 2013, Standing Cloud
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'firewall'

# open standard ssh port to tcp traffic only; enable firewall
firewall_rule "ssh" do
  port 22
  protocol :tcp
  source "#{node['scdevs']['internal_network']}"
  direction :in
  action :allow
  notifies :enable, "firewall[ufw]"
end

# open standard http/https ports to tcp traffic only
firewall_rule "http" do
  ports [ 80, 443 ]
  protocol :tcp
  source "#{node['scdevs']['internal_network']}"
  direction :in
  action :allow
end

# open port 8080 to tcp traffic only on trusted networks
node['scdevs']['trusted_networks'].each do |src|
  firewall_rule "http-alt-#{src}" do
    port_range 8080..8084
    protocol :tcp
    source "#{src}"
    direction :in
    action :allow
  end
end

firewall "ufw" do
  action :nothing
end
