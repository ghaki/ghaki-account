############################################################################
require 'mocha_helper'
require 'ghaki/account/username'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

module Ghaki module Account module UsernameTesting
describe Username do

  extend SynOptsHelper
  syn_opts_test_declare Username, :username, 'user',
    :user, :user_name

  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'eigen object' do
    syn_opts_test_class :username
    syn_opts_test_class_methods :username

    it { should respond_to :get_env }
    describe '#get_env' do
      it 'detects ENV value' do
        ::Etc.expects(:getlogin).returns('user')
        subject.get_env.should == 'user'
      end
    end

  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do
    syn_opts_test_object :username
    syn_opts_test_object_methods :username

    it { should respond_to :username }
    it { should respond_to :username= }
    it { should respond_to :valid_username? }

    it { should respond_to :ask_username }
    describe '#ask_username' do
      before(:each) do
        @high_mock = stub_everything()
        ::HighLine.stubs( :new => @high_mock )
      end
      it 'grabs username' do
        @high_mock.expects(:ask).returns('user').once
        subject.ask_username.should == 'user'
        subject.username.should == 'user'
      end
      it 'retries on failure' do
        @high_mock.expects(:ask).returns(nil,'user').twice
        subject.ask_username.should == 'user'
        subject.username.should == 'user'
      end
      it 'raises on failure' do
        @high_mock.expects(:ask).returns(nil).times(3)
        lambda do
          subject.ask_username
        end.should raise_error(InvalidUsernameError)
      end
    end


  end

end
end end end
