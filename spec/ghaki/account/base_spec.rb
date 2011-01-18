############################################################################
require 'ghaki/account/base'

############################################################################
module Ghaki module Account module BaseTesting
  describe Base do

    ########################################################################
    # CONSTANTS
    ########################################################################
    OPTS_HOS = { :hostname => 'host' }
    OPTS_USR = { :username => 'user' }
    OPTS_PAS = { :password => 'secret' }
    OPTS_EML = { :email_address => 'user@host' }
    OPTS_H_U = OPTS_HOS.merge(OPTS_USR)
    OPTS_ALL = OPTS_H_U.merge(OPTS_PAS).merge(OPTS_EML)
    EXTRA_OPTS = { :extra => true }

    ########################################################################
    # CLASS TESTS
    ########################################################################

    ########################################################################
    context 'class' do
      subject { Base }
      it { should respond_to :from_opts }
      it { should respond_to :purge_opts }
    end

    ########################################################################
    context 'class methods' do

      #---------------------------------------------------------------------
      describe '#from_opts' do
        it 'should accept separate' do
          acc = Base.from_opts(OPTS_ALL)
          acc.hostname.should == 'host'
          acc.username.should == 'user'
          acc.password.should == 'secret'
        end
        it 'should pass thru whole' do
          acc = Base.from_opts(OPTS_ALL)
          opts = { :account => acc }
          Base.from_opts(opts).should == acc
        end
      end

      #---------------------------------------------------------------------
      describe '#purge_opts' do
        it 'should remove' do
          Base.purge_opts(OPTS_ALL.merge(EXTRA_OPTS)).should eql(EXTRA_OPTS)
        end
      end

    end

    ########################################################################
    # OBJECT TESTS
    ########################################################################

    ########################################################################
    context 'object' do
      subject { Base.new }
      context 'included features' do
        it { should respond_to :hostname }
        it { should respond_to :username }
        it { should respond_to :password }
        it { should respond_to :email_address }
      end
      context 'new features' do
        it { should respond_to :expand_opts }
        it { should respond_to :collapse_opts }
        it { should respond_to :ask_all }
        it { should respond_to :to_s }
      end
    end

    ########################################################################
    context 'object methods' do

      #---------------------------------------------------------------------
      describe '#to_s' do
        it 'should make with hostname only' do
          Base.new(OPTS_HOS).to_s.should == '*@host'
        end
        it 'should make with username only' do
          Base.new(OPTS_USR).to_s.should == 'user@*'
        end
        it 'should make with username and hostname' do
          Base.new(OPTS_H_U).to_s.should == 'user@host'
        end
      end

      #---------------------------------------------------------------------
      describe '#email_address' do
        it 'should default with username only' do
          Base.new(OPTS_USR).email_address.should == 'user'
        end
        it 'should default with username and hostname' do
          Base.new(OPTS_H_U).email_address.should == 'user@host'
        end
        it 'should accept full email address' do
          Base.new(OPTS_EML).email_address.should == 'user@host'
        end
      end

      #---------------------------------------------------------------------
      describe '#collapse_opts' do
        before(:each) do
          @base = Base.new(OPTS_ALL)
          @opts = { :account => @base }
        end
        it 'should generate hash' do
          @base.collapse_opts.should eql(@opts)
        end
        it 'should merge hash' do
          @base.collapse_opts(EXTRA_OPTS).should eql(@opts.merge(EXTRA_OPTS))
        end
      end

      #---------------------------------------------------------------------
      describe '#expand_opts' do
        before(:each) do
          @base = Base.new(OPTS_ALL)
        end
        it 'should generate options' do
          @base.expand_opts.should eql(OPTS_ALL)
        end
        it 'should merge hash' do
          @base.expand_opts(EXTRA_OPTS).should eql(OPTS_ALL.merge(EXTRA_OPTS))
        end
      end

    end

  end
end end end
############################################################################
