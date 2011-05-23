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

    describe '#passwords' do
      it 'defaults empty when unset' do
        subject.passwords.should be_empty
      end
    end

    describe '#passwords=' do
      it 'accepts single password' do
        pass = 'secret'
        subject.passwords = pass
        subject.passwords.should == [pass]
      end
      it 'accepts several passwords' do
        pass = ['a','b']
        subject.passwords = pass
        subject.passwords.should == pass
      end
      it 'clears when given nil' do
        subject.passwords = nil
        subject.passwords.should be_empty
      end
    end

    describe '#password' do
      it 'returns nil when passwords is empty' do
        subject.password.should be_nil
      end
      it 'grabs first of passwords' do
        subject.passwords = ['a','b']
        subject.password.should == 'a'
      end
    end
    describe '#password=' do
      it 'aliases passwords=' do
        subject.method(:password=).should == subject.method(:passwords=)
      end
    end

    describe '#fail_password' do
      it 'advances to next password' do
        subject.passwords = ['a','b']
        subject.fail_password
        subject.password.should == 'b'
      end
      it 'runs out of passwords' do
        subject.passwords = ['a','b']
        subject.fail_password
        subject.fail_password
        subject.password.should be_nil
      end
    end

    describe '#retry_password?' do
      it 'handles no passwords' do
        subject.retry_password?.should be_false
      end
      it 'detects available password retries' do
        subject.passwords = ['a','b']
        subject.retry_password?.should be_true
      end
      it 'detects exhausted password retries' do
        subject.passwords = ['a']
        subject.fail_password
        subject.retry_password?.should be_false
      end
    end

    describe '#reset_passwords' do
      it 'resets password attempts' do
        subject.passwords = ['a','b']
        subject.fail_password
        subject.reset_passwords
        subject.password.should == 'a'
      end
    end

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
