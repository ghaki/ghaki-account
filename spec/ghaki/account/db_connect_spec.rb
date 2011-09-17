require 'ghaki/account/db_connect'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

module Ghaki module Account module DB_ConnectTesting
describe Ghaki::Account::DB_Connect do

  ########################################################################
  GOOD_EXAMPLE = 'dbi:Mysql:MYDB'
  extend SynOptsHelper
  syn_opts_test_declare DB_Connect, :db_connect, GOOD_EXAMPLE,
    :database_connect, :db_connector, :database_connector

  ########################################################################
  # EIGEN CLASS
  ########################################################################
  context 'eigen class' do
    syn_opts_test_class :db_connect
    syn_opts_test_class_methods :db_connect
  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do
    syn_opts_test_object :db_connect
    syn_opts_test_object_methods :db_connect


    it { should respond_to :valid_db_connect? }
    describe '#valid_db_connect?' do
      it "accepts <#{GOOD_EXAMPLE}>" do
        subject.db_connect = GOOD_EXAMPLE
        subject.valid_db_connect?.should be_true
      end
      it 'rejects when missing' do
        subject.db_connect = nil
        subject.valid_db_connect?.should be_false
      end
    end

    it { should respond_to :db_connect }
    it { should respond_to :db_connect= }
    describe '#db_connect' do
      require 'ghaki/account/hostname'
      require 'ghaki/account/db_driver'
      require 'ghaki/account/db_name'
      require 'ghaki/account/db_port'
      class UsingAll
        include DB_Connect
        include Hostname
        include DB_Driver
        include DB_Name
        include DB_Port
      end
      subject { UsingAll.new }
      it 'creates when all parts are present' do
        subject.db_driver   = 'Mysql'
        subject.hostname = 'db.host.com'
        subject.db_name = 'MYDB'
        subject.db_port = 1521
        subject.db_connect.should == 'dbi:Mysql:MYDB:db.host.com:1521'
      end
      it 'uses default localhost when port is present' do
        subject.db_driver   = 'Mysql'
        subject.db_name = 'MYDB'
        subject.db_port = 1521
        subject.db_connect.should == 'dbi:Mysql:MYDB:localhost:1521'
      end
      it 'skips default localhost when port is not present' do
        subject.db_driver   = 'Mysql'
        subject.db_name = 'MYDB'
        subject.db_connect.should == 'dbi:Mysql:MYDB'
      end
    end

  end

end
end end end
