############################################################################
require 'ghaki/account/username'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module UsernameTesting
  describe Username do

    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare Username, :username, 'user',
      :user, :user_name

    ########################################################################
    context 'class' do
      syn_opts_test_class :username
      it { should respond_to :get_env }
    end

    ########################################################################
    context 'class methods' do
      syn_opts_test_class_methods :username

      #---------------------------------------------------------------------
      describe '#get_env' do
        it 'should detect ENV value' do
          flexmock(:safe,Etc) do |fm|
            fm.should_receive(:getlogin).and_return('user')
          end
          subject.get_env.should == 'user'
        end
      end

    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################

    ########################################################################
    context 'objects' do
      syn_opts_test_object :username
      it { should respond_to :username }
      it { should respond_to :username= }
      it { should respond_to :ask_username }
      it { should respond_to :valid_username? }
    end

    ########################################################################
    context 'methods' do
      syn_opts_test_object_methods :username

      #---------------------------------------------------------------------
      describe '#ask_username' do
        before(:each) do
          @high_mock = flexmock()
          flexmock(:safe,HighLine) do |fm|
            fm.should_receive(:new).and_return(@high_mock)
          end
        end
        it 'should grab username' do
          @high_mock.should_receive(:ask).and_return('user')
          subject.ask_username.should == 'user'
          subject.username.should == 'user'
        end
        it 'should retry on failure' do
          @high_mock.should_receive(:ask).and_return(nil,'user')
          subject.ask_username.should == 'user'
          subject.username.should == 'user'
        end
        it 'should raise on failure' do
          @high_mock.should_receive(:ask).and_return(nil)
          lambda do
            subject.ask_username
          end.should raise_error(InvalidUsernameError)
        end
      end
    end

  end
end end end
############################################################################
