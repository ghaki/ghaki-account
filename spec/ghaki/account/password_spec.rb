############################################################################
require 'ghaki/account/password'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module PasswordTesting
  describe Password do

    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare Password, :password, 'secret'
    
    ########################################################################
    # OBJECT TESTING
    ########################################################################
    context 'class' do
      syn_opts_test_class :password
    end
    context 'class methods' do
      syn_opts_test_class_methods :password
    end

    ########################################################################
    context 'object' do
      syn_opts_test_object :password
      it { should respond_to :password }
      it { should respond_to :password= }
      it { should respond_to :ask_password }
      it { should respond_to :valid_password? }
    end

    ########################################################################
    context 'object methods' do
      syn_opts_test_object_methods :password

      #---------------------------------------------------------------------
      describe '#ask_password' do
        before(:each) do
          @high_mock = flexmock()
          flexmock(:safe,HighLine) do |fm|
            fm.should_receive(:new).and_return(@high_mock)
          end
        end
        it 'should grab password' do
          @high_mock.should_receive(:ask).and_return('secret')
          subject.ask_password.should == 'secret'
          subject.password.should == 'secret'
        end
        it 'should retry on failure' do
          @high_mock.should_receive(:ask).and_return(nil,'secret')
          subject.ask_password.should == 'secret'
          subject.password.should == 'secret'
        end
        it 'should raise on failure' do
          @high_mock.should_receive(:ask).and_return(nil)
          lambda do
            subject.ask_password
          end.should raise_error(InvalidPasswordError)
        end
      end

      #---------------------------------------------------------------------
      describe '#valid_password?' do
        it 'should deny missing' do
          subject.valid_password?.should be_false
        end
        it 'should accept present' do
          subject.password = 'secret'
          subject.valid_password?.should be_true
        end
      end

    end

  end
end end end
