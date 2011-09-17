require 'ghaki/account/db_driver'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

module Ghaki module Account module DB_DriverTesting
describe Ghaki::Account::DB_Driver do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare DB_Driver, :db_driver, 'dbi:Mysql', :database_driver

  ########################################################################
  # EIGEN CLASS
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :db_driver
    syn_opts_test_class_methods :db_driver
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do
    syn_opts_test_object :db_driver
    syn_opts_test_object_methods :db_driver

    it { should respond_to :db_driver }
    it { should respond_to :db_driver= }

    it { should respond_to :valid_db_driver? }
    describe '#valid_db_driver?' do
      it 'accepts <dbi:Mysql>' do
        subject.db_driver = 'dbi:Mysql'
        subject.valid_db_driver?.should be_true
      end
      it 'rejects when missing' do
        subject.db_driver = nil
        subject.valid_db_driver?.should be_false
      end
    end

  end

end
end end end
