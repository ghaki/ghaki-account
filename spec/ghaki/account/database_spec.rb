############################################################################
require 'ghaki/account/database'

############################################################################
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
    context 'class' do
      subject { Database }
      specify { subject.ancestors.should include(Base) }
    end

    ########################################################################
    context 'class methods' do

      #---------------------------------------------------------------------
      describe '#from_opts' do
        it 'should accept separate' do
          acc = Database.from_opts(OPTS_ALL)
          acc.db_driver.should == 'Mysql'
          acc.db_name.should == 'MYDB'
          acc.db_port.should == 1521
          acc.db_connect.should == 'dbi:Mysql:MYDB:db.host.com:1521'
        end
        it 'should pass thru whole' do
          acc = Database.from_opts(OPTS_ALL)
          Database.from_opts( :account => acc ).should eql(acc)
        end
      end

      #---------------------------------------------------------------------
      describe '#purge_opts' do
        it 'should remove' do
          Database.purge_opts(OPTS_ALL.merge(EXTRA_OPTS)).should eql(EXTRA_OPTS)
        end
      end

    end

    ########################################################################
    context 'object' do
      subject { Database.new }
      context 'partial included features' do
        it { should respond_to :db_driver }
        it { should respond_to :db_name }
        it { should respond_to :db_port }
        it { should respond_to :db_connect }
      end
    end

    ########################################################################
    context 'object methods' do

      #---------------------------------------------------------------------
      describe '#to_s' do
        it 'should make with just db name' do
          Database.new(OPTS_NAME).to_s.should == 'MYDB:*@localhost'
        end
        it 'should make with db and host' do
          Database.new(OPTS_ALL).to_s.should == 'MYDB:*@db.host.com'
        end
        it 'should make with db, host, and user' do
          Database.new(OPTS_ALL.merge(:username => 'user')).to_s.should == 'MYDB:user@db.host.com'
        end
      end

      #---------------------------------------------------------------------
      describe '#expand_opts' do
        it 'should make from scratch' do
          Database.new(OPTS_ALL).expand_opts.should eql(OPTS_ALL)
        end
        it 'should make using passed' do
          Database.new(OPTS_ALL).expand_opts(EXTRA_OPTS.dup).should eql(OPTS_ALL.merge(EXTRA_OPTS))
        end
      end

      #---------------------------------------------------------------------
      describe '#collapse_opts' do
        before(:each) do
          @base = Database.new(OPTS_ALL)
        end
        it 'should make from scratch' do
          @opts = { :account => @base }
          @base.collapse_opts.should eql(@opts)
        end
        it 'should make using passed' do
          @opts = EXTRA_OPTS.merge( :account => @base )
          @base.collapse_opts(EXTRA_OPTS.dup).should eql(@opts)
        end
      end

    end

  end
end end end
############################################################################
