# -*- coding: UTF-8 -*-
#
# Cookbook Name:: sample
# Recipe:: default
#
# Copyright (C) 2013 Dave Shawley
#
# All rights reserved - Do Not Redistribute
#

directory '/vagrant/test' do
  action :create
  recursive true
end

file '/vagrant/test/sample_test.bats' do
  content <<-EOH
    @test "write a state file" {
      echo 'I ran during the converge' > /tmp/run-during-converge
    }
  EOH
end
