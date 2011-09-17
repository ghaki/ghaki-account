require 'ghaki/account/db_name'
require File.join( File.dirname(__FILE__),'syn_opts_helper' )

module Ghaki module Account module DB_NameTesting
describe Ghaki::Account::DB_Name do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare DB_Name, :db_name, 'MYDB', :database_name

  ########################################################################
  # EIGEN CLASS
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :db_name
    syn_opts_test_class_methods :db_name
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'objects' do
    syn_opts_test_object :db_name
    syn_opts_test_object_methods :db_name

    it { should respond_to :db_name }
    it { should respond_to :db_name= }

    it { should respond_to :valid_db_name? }
    describe '#valid_db_name?' do
      it 'accepts <MYDB>' do
        subject.db_name = 'MYDB'
        subject.valid_db_name?.should be_true
      end
      it 'rejects when missing' do
        subject.db_name = nil
        subject.valid_db_name?.should be_false
      end
    end
  end

end
end end end
