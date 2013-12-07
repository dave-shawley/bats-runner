# -*- coding: UTF-8 -*-
#
# Cookbook Name:: bats-runner
# Library:: BatsChefHandler
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

require 'chef'

module BatsChefHandler
  class Handler < ::Chef::Handler
    include Chef::Mixin::ShellOut

    def report
      return if failed?

      result = run_tests
      log_output result.stdout

      if result.exitstatus.nonzero?
        log_output result.stderr
        Chef::Client.when_run_completes_successfully do
          fail 'Testing with BATS failed'
        end
      end
    end

    def run_tests
      bats_root = node[:bats_runner][:bats_root]
      test_root = node[:bats_runner][:test_root]

      Chef::Log.info "Running BATS tests in #{test_root}"
      shell_out(
        [File.join(bats_root, 'bin', 'bats'),
          Dir.glob(File.join(test_root, '**', '*.bats'))
        ].flatten.join(' '))
    end

    def log_output(stdout)
      stdout.each_line do |line|
        if line.start_with? 'not ok'
          Chef::Log.error "BATS: #{line.chomp}"
        else
          Chef::Log.info "BATS: #{line.chomp}"
        end
      end
    end
  end

  Chef::Log.info 'Enabling the BATS Chef Handler'
  Chef::Config.send('report_handlers') << BatsChefHandler::Handler.new
end
