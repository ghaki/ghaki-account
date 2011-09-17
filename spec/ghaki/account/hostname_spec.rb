require 'ghaki/account/hostname'
require File.join( File.dirname(__FILE__), 'syn_opts_helper' )

############################################################################
module Ghaki module Account module HostnameTesting
describe Hostname do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare Hostname, :hostname, 'host', :host, :host_name

  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :hostname
    syn_opts_test_class_methods :hostname

    #---------------------------------------------------------------------
    it { should respond_to :get_env }
    describe '#get_env' do
      it 'detects ENV value' do
        ENV['HOSTNAME'] = 'host'
        subject.get_env.should == 'host'
      end
      it 'gets socket name' do
        ENV.delete('HOSTNAME')
        ::Socket.expects(:gethostname).returns('host')
        subject.get_env.should == 'host'
      end
    end

  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object' do
    syn_opts_test_object :hostname
    syn_opts_test_object_methods :hostname

    it { should respond_to :hostname }
    it { should respond_to :hostname= }
    it { should respond_to :ask_hostname }
    it { should respond_to :valid_hostname? }

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
        @high_mock = stub_everything()
        ::HighLine.stubs( :new => @high_mock )
      end
      it 'should grab hostname' do
        @high_mock.expects(:ask).returns('host')
        subject.ask_hostname.should == 'host'
        subject.hostname.should == 'host'
      end
      it 'should retry on failure' do
        @high_mock.expects(:ask).returns('host bad','host').twice
        subject.ask_hostname.should == 'host'
        subject.hostname.should == 'host'
      end
      it 'should raise on failure' do
        @high_mock.expects(:ask).returns('host bad').times(3)
        lambda do
          subject.ask_hostname
        end.should raise_error(InvalidHostnameError)
      end
    end

  end

end
end end end
