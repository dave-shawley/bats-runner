# -*- coding: UTF-8 -*-
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe command('git --version') do
  it { should return_exit_status 0 }
end

describe file('/opt/bats') do
  it { should be_directory }
end

describe file('/opt/bats/bin/bats') do
  it { should be_file }
  it { should be_executable }
end
