require 'ghaki/account/db_port'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

module Ghaki module Account module DB_PortTesting
describe Ghaki::Account::DB_Port do

  ########################################################################
  extend SynOptsHelper
  syn_opts_test_declare DB_Port, :db_port, 1521, :database_port

  ########################################################################
  # EIGEN CLASS
  ########################################################################
  context 'class' do
    syn_opts_test_class :db_port
    syn_opts_test_class_methods :db_port
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'objects' do

    syn_opts_test_object :db_port
    syn_opts_test_object_methods :db_port

    it { should respond_to :db_port }
    it { should respond_to :db_port= }

    it { should respond_to :valid_db_port? }
    describe '#valid_db_port?' do
      it 'accepts <1521>' do
        subject.db_port = 1521
        subject.valid_db_port?.should be_true
      end
      it 'accepts when missing' do
        subject.db_port = nil
        subject.valid_db_port?.should be_true
      end
      it 'rejects when NAN' do
        subject.db_port = 'moo'
        subject.valid_db_port?.should be_false
      end
    end

  end

end
end end end
