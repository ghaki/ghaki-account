require 'mocha_helper'
require 'ghaki/account/database'

module Ghaki module Account module DatabaseTesting
describe Database do

  ########################################################################
  OPTS_NAME = { :db_name => 'MYDB' }
  OPTS_DRIV = { :db_driver => 'Mysql' }
  OPTS_PORT = { :db_port => 1521 }
  OPTS_HOST = { :hostname => 'db.host.com' }
  OPTS_ALL = OPTS_NAME.merge(OPTS_DRIV).merge(OPTS_PORT).merge(OPTS_HOST)
  EXTRA_OPTS = { :extra => true }

  ########################################################################
  # EIGEN TESTING
  ########################################################################
  context 'class' do
    subject { Database }
    specify { subject.ancestors.should include(Base) }
    specify { subject.ancestors.should include(DB_Name) }
    specify { subject.ancestors.should include(DB_Port) }
    specify { subject.ancestors.should include(DB_Driver) }
    specify { subject.ancestors.should include(DB_Connect) }

    #---------------------------------------------------------------------
    describe '#from_opts' do
      it 'accepts separate' do
        acc = Database.from_opts(OPTS_ALL)
        acc.db_driver.should == 'Mysql'
        acc.db_name.should == 'MYDB'
        acc.db_port.should == 1521
        acc.db_connect.should == 'dbi:Mysql:MYDB:db.host.com:1521'
      end
      it 'passes thru whole' do
        acc = Database.from_opts(OPTS_ALL)
        Database.from_opts( :account => acc ).should eql(acc)
      end
    end

    #---------------------------------------------------------------------
    describe '#purge_opts' do
      it 'removes separate login parts' do
        Database.purge_opts(OPTS_ALL.merge(EXTRA_OPTS)).should eql(EXTRA_OPTS)
      end
    end

  end

  ########################################################################
  # INSTANCE TESTING
  ########################################################################
  context 'object instance' do

    #---------------------------------------------------------------------
    describe '#to_s' do
      it 'creates from just db name' do
        Database.new(OPTS_NAME).to_s.should == 'MYDB:*@localhost'
      end
      it 'creates from db and host' do
        Database.new(OPTS_ALL).to_s.should == 'MYDB:*@db.host.com'
      end
      it 'creates from with db, host, and user' do
        Database.new(OPTS_ALL.merge(:username => 'user')).to_s.should == 'MYDB:user@db.host.com'
      end
    end

    #---------------------------------------------------------------------
    describe '#expand_opts' do
      it 'creates from scratch' do
        Database.new(OPTS_ALL).expand_opts.should eql(OPTS_ALL)
      end
      it 'creates using passed' do
        Database.new(OPTS_ALL).expand_opts(EXTRA_OPTS.dup).should eql(OPTS_ALL.merge(EXTRA_OPTS))
      end
    end

    #---------------------------------------------------------------------
    describe '#collapse_opts' do
      before(:each) do
        @base = Database.new(OPTS_ALL)
      end
      it 'creates from scratch' do
        @opts = { :account => @base }
        @base.collapse_opts.should eql(@opts)
      end
      it 'creates passed' do
        @opts = EXTRA_OPTS.merge( :account => @base )
        @base.collapse_opts(EXTRA_OPTS.dup).should eql(@opts)
      end
    end

  end

end
end end end
############################################################################
