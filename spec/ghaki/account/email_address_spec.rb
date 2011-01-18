############################################################################
require 'ghaki/account/email_address'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module EMailAddressTesting
  describe EMailAddress do

    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare EMailAddress, :email_address, 'user@host', :email

    ########################################################################
    # CLASS TESTING
    ########################################################################
    context 'class' do
      syn_opts_test_class :email_address
    end
    context 'class methods' do
      syn_opts_test_class_methods :email_address
    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################
    context 'object' do
      syn_opts_test_object :email_address
      it { should respond_to :email_address }
      it { should respond_to :email_address= }
    end
    context 'object_methods' do
      syn_opts_test_object_methods :email_address
    end

  end
end end end
############################################################################
