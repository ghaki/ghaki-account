require 'ghaki/account/base'

module Ghaki module Account module BaseTesting
describe Base do

  ########################################################################
  # CONSTANTS
  ########################################################################
  OPTS_HOS = { :hostname => 'host' }
  OPTS_USR = { :username => 'user' }
  OPTS_PAS = { :password => ['secret'] }
  OPTS_EML = { :email_address => 'user@host' }
  OPTS_H_U = OPTS_HOS.merge(OPTS_USR)
  OPTS_ALL = OPTS_H_U.merge(OPTS_PAS).merge(OPTS_EML)
  EXTRA_OPTS = { :extra => true }

  ########################################################################
  # EIGEN TESTS
  ########################################################################
  context 'eigen class' do
    specify { Base.ancestors.should include(Hostname) }
    specify { Base.ancestors.should include(Username) }
    specify { Base.ancestors.should include(Password) }
    specify { Base.ancestors.should include(EMailAddress) }
    subject { Base }
    it { should respond_to :from_opts }
    it { should respond_to :purge_opts }

    #---------------------------------------------------------------------
    describe '#from_opts' do
      it 'accepts separate login parts' do
        acc = Base.from_opts(OPTS_ALL)
        acc.hostname.should == 'host'
        acc.username.should == 'user'
        acc.password.should == 'secret'
      end
      it 'passes thru account object' do
        acc = Base.from_opts(OPTS_ALL)
        opts = { :account => acc }
        Base.from_opts(opts).should == acc
      end
    end

    #---------------------------------------------------------------------
    describe '#purge_opts' do
      it 'removes separate login parts' do
        Base.purge_opts(OPTS_ALL.merge(EXTRA_OPTS)).should eql(EXTRA_OPTS)
      end
    end

  end

  ########################################################################
  # INSTANCE TESTS
  ########################################################################
  context 'object instance' do
    subject { Base.new }

    it { should respond_to :ask_all }

    #---------------------------------------------------------------------
    it { should respond_to :to_s }
    describe '#to_s' do
      it 'creates from hostname only' do
        Base.new(OPTS_HOS).to_s.should == '*@host'
      end
      it 'creates from username only' do
        Base.new(OPTS_USR).to_s.should == 'user@*'
      end
      it 'creates from username and hostname' do
        Base.new(OPTS_H_U).to_s.should == 'user@host'
      end
    end

    #---------------------------------------------------------------------
    describe '#email_address' do
      it 'defaults with username only' do
        Base.new(OPTS_USR).email_address.should == 'user'
      end
      it 'defaults with username and hostname' do
        Base.new(OPTS_H_U).email_address.should == 'user@host'
      end
      it 'accepts full email address' do
        Base.new(OPTS_EML).email_address.should == 'user@host'
      end
    end

    #---------------------------------------------------------------------
    it { should respond_to :collapse_opts }
    describe '#collapse_opts' do
      before(:each) do
        @base = Base.new(OPTS_ALL)
        @opts = { :account => @base }
      end
      it 'generates account pair' do
        @base.collapse_opts.should eql(@opts)
      end
      it 'ignores extra hash pairs' do
        @base.collapse_opts(EXTRA_OPTS).should eql(@opts.merge(EXTRA_OPTS))
      end
    end

    #---------------------------------------------------------------------
    it { should respond_to :expand_opts }
    describe '#expand_opts' do
      before(:each) do
        @base = Base.new(OPTS_ALL)
      end
      it 'generates separate login pairs' do
        @base.expand_opts.should eql(OPTS_ALL)
      end
      it 'ignores extra hash pairs' do
        @base.expand_opts(EXTRA_OPTS).should eql(OPTS_ALL.merge(EXTRA_OPTS))
      end
    end

  end

end
end end end
############################################################################
