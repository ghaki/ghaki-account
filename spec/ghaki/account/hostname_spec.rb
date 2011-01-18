############################################################################
require 'ghaki/account/hostname'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module HostnameTesting
  describe Hostname do

    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare Hostname, :hostname, 'host', :host, :host_name

    ########################################################################
    # CLASS TESTING
    ########################################################################

    #=======================================================================
    context 'class' do
      syn_opts_test_class :hostname
      it { should respond_to :get_env }
    end

    #=======================================================================
    context 'class methods' do
      syn_opts_test_class_methods :hostname

      #---------------------------------------------------------------------
      describe '#get_env' do
        it 'should detect ENV value' do
          ENV['HOSTNAME'] = 'host'
          subject.get_env.should == 'host'
        end
        it 'should get socket name' do
          ENV.delete('HOSTNAME')
          flexmock(:safe,Socket) do |fm|
            fm.should_receive(:gethostname).and_return('host')
          end
          subject.get_env.should == 'host'
        end
      end

    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################

    #=======================================================================
    context 'object' do
      syn_opts_test_object :hostname
      it { should respond_to :hostname }
      it { should respond_to :hostname= }
      it { should respond_to :ask_hostname }
      it { should respond_to :valid_hostname? }
    end

    #=======================================================================
    context 'object_methods' do
      syn_opts_test_object_methods :hostname

      #---------------------------------------------------------------------
      describe '#hostname=' do
        it 'should accept ENV default' do
          ENV['HOSTNAME'] = 'host'
          subject.hostname = :env
          subject.hostname.should == 'host'
        end
        it 'should trim whitespace' do
          subject.hostname = ' host '
          subject.hostname.should == 'host'
        end
      end

      #---------------------------------------------------------------------
      describe '#valid_hostname?' do
        it 'should deny missing' do
          subject.valid_hostname?.should be_false
        end
        it 'should deny empty' do
          subject.hostname = ''
          subject.valid_hostname?.should be_false
        end
        it 'should deny inner whitespace' do
          subject.hostname = 'quack moo'
          subject.valid_hostname?.should be_false
        end
        it 'should accept single word' do
          subject.hostname = 'host'
          subject.valid_hostname?.should be_true
        end
        it 'should accept fully qualified' do
          subject.hostname = 'host.domain'
          subject.valid_hostname?.should be_true
        end
      end

      #---------------------------------------------------------------------
      describe '#ask_hostname' do
        before(:each) do
          @high_mock = flexmock()
          flexmock(:safe,HighLine) do |fm|
            fm.should_receive(:new).and_return(@high_mock)
          end
        end
        it 'should grab hostname' do
          @high_mock.should_receive(:ask).and_return('host')
          subject.ask_hostname.should == 'host'
          subject.hostname.should == 'host'
        end
        it 'should retry on failure' do
          @high_mock.should_receive(:ask).and_return('host bad','host')
          subject.ask_hostname.should == 'host'
          subject.hostname.should == 'host'
        end
        it 'should raise on failure' do
          @high_mock.should_receive(:ask).and_return('host bad')
          lambda do
            subject.ask_hostname
          end.should raise_error(InvalidHostnameError)
        end
      end

    end

  end
end end end
############################################################################