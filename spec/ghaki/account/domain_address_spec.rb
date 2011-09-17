require 'ghaki/account/domain_address'
require File.join( File.dirname(__FILE__), 'syn_opts_helper' )

module Ghaki module Account module DomainAddressTesting
describe DomainAddress do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare DomainAddress, :domain_address, "\\\\domain\\user"

  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :domain_address
    syn_opts_test_class_methods :domain_address
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do
    syn_opts_test_object :domain_address
    syn_opts_test_object_methods :domain_address
    it { should respond_to :domain_address }
    it { should respond_to :domain_address= }
  end

end
end end end
