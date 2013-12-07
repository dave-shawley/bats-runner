# -*- coding: UTF-8 -*-
#
# Cookbook Name:: bats-runner
# Attribute Set:: default
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

default[:bats_runner][:git_repo] = 'https://github.com/sstephenson/bats.git'
default[:bats_runner][:bats_revision] = 'v0.3.1'

default[:bats_runner][:bats_root] = '/opt/bats'
default[:bats_runner][:test_root] = '/vagrant/test'
