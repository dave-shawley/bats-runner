# -*- coding: UTF-8 -*-
#
# Cookbook Name:: bats-runner
# Recipe:: install-bats
#
# Copyright 2013, Dave Shawley
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

package 'git' do
  package_name case node[:platform_family]
               when 'debian' then 'git-core'
               else 'git'
               end
end

git 'BATS repository' do
  repository node[:bats_runner][:git_repo]
  destination File.join(Chef::Config[:file_cache_path], 'bats')
  action :checkout
  revision node[:bats_runner][:bats_revision]
end

directory 'BATS directory' do
  action :create
  owner 'root'
  path node[:bats_runner][:bats_root]
end

bash 'install bats' do
  cwd "#{Chef::Config[:file_cache_path]}/bats"
  code "./install.sh #{node[:bats_runner][:bats_root]}"
end
