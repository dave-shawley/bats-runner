# -*- coding: UTF-8 -*-
require 'spec_helper'

describe 'bats-runner::install-bats' do
  before(:each) do
    @chef_run = ChefSpec::Runner.new
  end

  context 'recipe' do
    subject { @chef_run.converge described_recipe }
    it { should install_package 'git' }
    it { should create_directory 'BATS directory' }
    it { should checkout_git 'BATS repository' }
    it { should run_bash 'install bats' }
  end

  context 'when installing BATS into BATS_ROOT' do
    subject do
      @chef_run.node.set[:bats_runner] = { bats_root: 'BATS_ROOT' }
      @chef_run.converge described_recipe
      @chef_run.find_resource 'bash', 'install bats'
    end
    its(:cwd) { should eq "#{Chef::Config[:file_cache_path]}/bats" }
    its(:code) { should eq './install.sh BATS_ROOT' }
    its(:action) { should eq 'run' }
  end

  context 'when checking out of TAG from REPO' do
    subject do
      @chef_run.node.set[:bats_runner][:git_repo] = 'REPO'
      @chef_run.node.set[:bats_runner][:bats_revision] = 'TAG'
      @chef_run.converge described_recipe
      @chef_run.find_resource 'git', 'BATS repository'
    end
    its(:repository) { should eq 'REPO' }
    its(:revision) { should eq 'TAG' }
    its(:destination) { should eq "#{Chef::Config[:file_cache_path]}/bats" }
  end

  context 'when BATS installation directory is /tmp' do
    subject do
      @chef_run.node.set[:bats_runner] = { bats_root: '/tmp' }
      @chef_run.converge described_recipe
      @chef_run.find_resource 'directory', 'BATS directory'
    end
    its(:action) { should eq [:create] }
    its(:owner) { should eq 'root' }
    its(:path) { should eq '/tmp' }
  end

  context 'installs git' do
    context 'under Ubuntu' do
      subject do
        @chef_run = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
        @chef_run.converge described_recipe
        @chef_run.find_resource 'package', 'git'
      end
      its(:package_name) { should eq 'git-core' }
    end

    context 'under RHEL' do
      subject do
        @chef_run = ChefSpec::Runner.new(platform: 'centos', version: '6.4')
        @chef_run.converge described_recipe
        @chef_run.find_resource 'package', 'git'
      end
      its(:package_name) { should eq 'git' }
    end
  end
end
