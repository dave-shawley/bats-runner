# -*- coding: UTF-8 -*-
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe file('/tmp/run-during-converge') do
  its(:content) { should eq "I ran during the converge\n" }
end
