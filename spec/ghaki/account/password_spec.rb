require 'mocha_helper'
require 'ghaki/account/password'
require File.join( File.dirname(__FILE__), 'syn_opts_helper' )

module Ghaki module Account module PasswordTesting
describe Password do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare Password, :password, 'secret'
  
  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'eigen class' do
    subject { Password }
    syn_opts_test_class :password
    syn_opts_test_class_methods :password
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do
    syn_opts_test_object :password
    syn_opts_test_object_methods :password

    it { should respond_to :password }
    it { should respond_to :password= }

    #---------------------------------------------------------------------
    it { should respond_to :ask_password }
    describe '#ask_password' do
      before(:each) do
        @high_mock = stub_everything()
        ::HighLine.stubs( :new => @high_mock )
      end
      it 'grabs password' do
        @high_mock.expects(:ask).returns('secret').once
        subject.ask_password.should == 'secret'
        subject.password.should == 'secret'
      end
      it 'retries on failure' do
        @high_mock.expects(:ask).returns(nil,'secret').twice
        subject.ask_password.should == 'secret'
        subject.password.should == 'secret'
      end
      it 'raises on failure' do
        @high_mock.expects(:ask).returns(nil).times(3)
        lambda do
          subject.ask_password
        end.should raise_error(InvalidPasswordError)
      end
    end

    #---------------------------------------------------------------------
    it { should respond_to :valid_password? }
    describe '#valid_password?' do
      it 'denies missing' do
        subject.valid_password?.should be_false
      end
      it 'accepts present' do
        subject.password = 'secret'
        subject.valid_password?.should be_true
      end
    end

  end

end
end end end
