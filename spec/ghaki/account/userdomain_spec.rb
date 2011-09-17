require 'ghaki/account/userdomain'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module UserDomainTesting
describe UserDomain do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare UserDomain, :userdomain, 'domain', :user_domain

  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :userdomain
    syn_opts_test_class_methods :userdomain

    it { should respond_to :get_env }

    describe '#get_env' do
      it 'detects ENV value' do
        ENV['USERDOMAIN'] = 'domain'
        subject.get_env.should == 'domain'
      end
    end

  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do

    syn_opts_test_object :userdomain
    syn_opts_test_object_methods :userdomain

    it { should respond_to :userdomain }
    it { should respond_to :userdomain= }
    it { should respond_to :valid_userdomain? }

    #---------------------------------------------------------------------
    it { should respond_to :ask_userdomain }
    describe '#ask_userdomain' do
      before(:each) do
        @high_mock = stub_everything()
        ::HighLine.stubs( :new => @high_mock )
      end
      it 'grabs user domain' do
        @high_mock.expects(:ask).returns('domain').once
        subject.ask_userdomain.should == 'domain'
        subject.userdomain.should == 'domain'
      end
      it 'retries on failure' do
        @high_mock.expects(:ask).returns('domain bad','domain').twice
        subject.ask_userdomain.should == 'domain'
        subject.userdomain.should == 'domain'
      end
      it 'raises on failure' do
        @high_mock.expects(:ask).returns('domain bad').times(3)
        lambda do
          subject.ask_userdomain
        end.should raise_error(InvalidUserDomainError)
      end
    end
  end

end
end end end
