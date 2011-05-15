require 'mocha_helper'
require 'ghaki/account/email_address'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

module Ghaki module Account module EMailAddressTesting
describe EMailAddress do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare EMailAddress, :email_address, 'user@host', :email

  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :email_address
    syn_opts_test_class_methods :email_address
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do
    syn_opts_test_object :email_address
    syn_opts_test_object_methods :email_address
    it { should respond_to :email_address }
    it { should respond_to :email_address= }
  end

end
end end end
