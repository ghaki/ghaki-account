############################################################################
require 'ghaki/account/db_driver'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module DB_DriverTesting
  describe Ghaki::Account::DB_Driver do

    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare DB_Driver, :db_driver, 'dbi:Mysql', :database_driver

    ########################################################################
    context 'class' do
      syn_opts_test_class :db_driver
    end

    ########################################################################
    context 'class methods' do
      syn_opts_test_class_methods :db_driver
    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################

    ########################################################################
    context 'objects' do
      syn_opts_test_object :db_driver
      it { should respond_to :db_driver }
      it { should respond_to :db_driver= }
      it { should respond_to :valid_db_driver? }
    end

    ########################################################################
    context 'methods' do
      syn_opts_test_object_methods :db_driver
      describe '#valid_db_driver?' do
        it 'should accept <dbi:Mysql>' do
          subject.db_driver = 'dbi:Mysql'
          subject.valid_db_driver?.should be_true
        end
        it 'should reject when missing' do
          subject.db_driver = nil
          subject.valid_db_driver?.should be_false
        end
      end
    end

  end
end end end
############################################################################
