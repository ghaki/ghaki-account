############################################################################
require 'mocha_helper'
require 'ghaki/account/db_connect'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account module DB_ConnectTesting
  describe Ghaki::Account::DB_Connect do

    ########################################################################
    GOOD_EXAMPLE = 'dbi:Mysql:MYDB'
    extend SynOptsHelper
    syn_opts_test_declare DB_Connect, :db_connect, GOOD_EXAMPLE,
      :database_connect, :db_connector, :database_connector

    ########################################################################
    context 'class' do
      syn_opts_test_class :db_connect
    end

    ########################################################################
    context 'class methods' do
      syn_opts_test_class_methods :db_connect
    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################

    ########################################################################
    context 'objects' do
      syn_opts_test_object :db_connect
      it { should respond_to :db_connect }
      it { should respond_to :db_connect= }
      it { should respond_to :valid_db_connect? }
    end

    ########################################################################
    context 'methods' do

      syn_opts_test_object_methods :db_connect

      describe '#valid_db_connect?' do
        it "should accept <#{GOOD_EXAMPLE}>" do
          subject.db_connect = GOOD_EXAMPLE
          subject.valid_db_connect?.should be_true
        end
        it 'should reject when missing' do
          subject.db_connect = nil
          subject.valid_db_connect?.should be_false
        end
      end

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
        it 'should make with all parts' do
          subject.db_driver   = 'Mysql'
          subject.hostname = 'db.host.com'
          subject.db_name = 'MYDB'
          subject.db_port = 1521
          subject.db_connect.should == 'dbi:Mysql:MYDB:db.host.com:1521'
        end
        it 'should not default with localhost without port' do
          subject.db_driver   = 'Mysql'
          subject.db_name = 'MYDB'
          subject.db_connect.should == 'dbi:Mysql:MYDB'
        end
        it 'should default with localhost with port' do
          subject.db_driver   = 'Mysql'
          subject.db_name = 'MYDB'
          subject.db_port = 1521
          subject.db_connect.should == 'dbi:Mysql:MYDB:localhost:1521'
        end
        it 'should default empty with no port' do
          subject.db_driver   = 'Mysql'
          subject.db_name = 'MYDB'
          subject.db_connect.should == 'dbi:Mysql:MYDB'
        end
      end

    end

  end
end end end
############################################################################
