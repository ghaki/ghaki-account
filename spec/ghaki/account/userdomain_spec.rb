############################################################################
require 'ghaki/account/userdomain'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module UserDomainTesting
  describe UserDomain do


    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare UserDomain, :userdomain, 'domain', :user_domain

    ########################################################################
    # CLASS TESTING
    ########################################################################

    ########################################################################
    context 'class' do
      syn_opts_test_class :userdomain
      it { should respond_to :get_env }
    end

    ########################################################################
    context 'class methods' do
      syn_opts_test_class_methods :userdomain

      #---------------------------------------------------------------------
      describe '#get_env' do
        it 'should detect ENV value' do
          ENV['USERDOMAIN'] = 'domain'
          subject.get_env.should == 'domain'
        end
      end

    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################

    ########################################################################
    context 'object' do
      syn_opts_test_object :userdomain
      it { should respond_to :userdomain }
      it { should respond_to :userdomain= }
      it { should respond_to :ask_userdomain }
      it { should respond_to :valid_userdomain? }
    end

    ########################################################################
    context 'object methods' do
      syn_opts_test_object_methods :userdomain

      #---------------------------------------------------------------------
      describe '#ask_userdomain' do
        before(:each) do
          @high_mock = flexmock()
          flexmock(:safe,HighLine) do |fm|
            fm.should_receive(:new).and_return(@high_mock)
          end
        end
        it 'should grab user domain' do
          @high_mock.should_receive(:ask).and_return('domain')
          subject.ask_userdomain.should == 'domain'
          subject.userdomain.should == 'domain'
        end
        it 'should retry on failure' do
          @high_mock.should_receive(:ask).and_return('domain bad','domain')
          subject.ask_userdomain.should == 'domain'
          subject.userdomain.should == 'domain'
        end
        it 'should raise on failure' do
          @high_mock.should_receive(:ask).and_return('domain bad')
          lambda do
            subject.ask_userdomain
          end.should raise_error(InvalidUserDomainError)
        end
      end
    end

  end
end end end
