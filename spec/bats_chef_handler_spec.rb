# -*- coding: UTF-8 -*-
require 'spec_helper'

require 'chef'
require 'bats_chef_handler'

describe BatsChefHandler::Handler do

  context 'the class' do
    it { should be_kind_of ::Chef::Handler }
  end

  describe '#report' do
    context 'when Chef run succeeded' do
      subject do
        handler = described_class.new
        handler.stub(:node).and_return(bats_runner: {
          bats_root: 'BATS_ROOT',
          test_root: 'TESTS_ROOT',
        })
        handler
      end
      let(:result) { double }

      before(:each) do
        expect(Dir).to receive(:glob).with(
          'TESTS_ROOT/**/*.bats').and_return('TESTS TO RUN')
        Chef::Log.stub(:info)

        expect(subject).to receive(:failed?).and_return(false)
        expect(subject).to receive(:shell_out).with(
          'BATS_ROOT/bin/bats TESTS TO RUN').and_return(result)
      end

      after(:each) do
        Chef::Log.should have_received(:info).with(
          'Running BATS tests in TESTS_ROOT')
      end

      shared_examples 'BATS test runner' do
        it 'runs bats via shell out' do
          expect(result).to receive(:stdout).and_return('')
          subject.report
        end

        it 'logs failures with Chef::Log.error' do
          expect(result).to receive(:stdout).and_return("not ok 1 failed\n")
          expect(Chef::Log).to receive(:error).with('BATS: not ok 1 failed')

          subject.report
        end

        it 'logs successes with Chef::Log.info' do
          expect(result).to receive(:stdout).and_return("ok 1 succeeded\n")
          subject.report

          Chef::Log.should have_received(:info).with('BATS: ok 1 succeeded')
        end
      end

      context 'and BATS tests succeed' do
        before(:each) do
          expect(result).to receive(:exitstatus).and_return(0)
          expect(Chef::Client).to_not receive(:when_run_completes_successfully)
        end
        it_should_behave_like 'BATS test runner'
      end

      context 'and BATS tests fail' do
        before(:each) do
          expect(result).to receive(:exitstatus).and_return(1)
          expect(result).to receive(:stderr).and_return(
            "TWO LINES OF\nSTDERR OUTPUT")
          expect(Chef::Client).to receive(:when_run_completes_successfully) do
            |&arg|
            @captured_block = arg
          end
        end

        it_should_behave_like 'BATS test runner'

        context 'it calls Chef::Client.when_run_completes_successfully' do
          before(:each) do
            expect(result).to receive(:stdout).and_return('')
            subject.report
          end

          it 'passes a block' do
            expect(@captured_block).to be_a(Proc)
          end

          it 'raises a RuntimeError from the block' do
            expect { @captured_block.call }.to raise_error(RuntimeError)
          end
        end

        it 'logs stderr output from command' do
          expect(result).to receive(:stdout).and_return('')

          subject.report

          Chef::Log.should have_received(:info).with('BATS: TWO LINES OF')
          Chef::Log.should have_received(:info).with('BATS: STDERR OUTPUT')
        end
      end
    end
  end
end
