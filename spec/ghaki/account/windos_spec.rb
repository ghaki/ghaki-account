require 'ghaki/account/windos'

module Ghaki module Account module WinDosTesting
describe WinDos do

  ########################################################################
  # CONSTANTS
  ########################################################################
  OPTS_NAM = { :username => 'user' }
  OPTS_DOM = { :userdomain => 'domain' }
  OPTS_DAD = { :domain_address => "\\\\domain\\user" }
  OPTS_ALL = OPTS_NAM.merge(OPTS_DOM).merge(OPTS_DAD )
  EXTRA_OPTS = { :extra => true }

  ########################################################################
  # EIGEN TESTS
  ########################################################################
  context 'class' do
    subject { WinDos }
    specify { subject.ancestors.should include(Base) }
    specify { subject.ancestors.should include(UserDomain) }
    specify { subject.ancestors.should include(DomainAddress) }

    #---------------------------------------------------------------------
    describe '#from_opts' do
      it 'accepts separate' do
        acc = WinDos.from_opts(OPTS_ALL)
        acc.username.should == 'user'
        acc.userdomain.should == 'domain'
      end
      it 'passes thru whole' do
        acc = WinDos.from_opts(OPTS_ALL)
        opts = { :account => acc }
        WinDos.from_opts(opts).should eql(acc)
      end
    end

    #---------------------------------------------------------------------
    describe '#purge_opts' do
      it 'remove separate login parts' do
        WinDos.purge_opts(OPTS_ALL.merge(EXTRA_OPTS)).should eql(EXTRA_OPTS)
      end
    end

  end

  ########################################################################
  # INSTANCE TESTS
  ########################################################################
  context 'object instance' do

    #---------------------------------------------------------------------
    describe '#to_s' do
      it 'defaults using user domain only' do
        WinDos.new(OPTS_DOM).to_s.should == "\\\\domain\\*"
      end
      it 'defaults using username only' do
        WinDos.new(OPTS_NAM).to_s.should == "\\\\*\\user"
      end
      it 'defaults using username and domain' do
        WinDos.new(OPTS_ALL).to_s.should == "\\\\domain\\user"
      end
    end

    #---------------------------------------------------------------------
    describe '#domain_address' do
      it 'accepts domain address directly' do
        WinDos.new(OPTS_DAD).domain_address.should == "\\\\domain\\user"
      end
      it 'defaults from username only' do
        WinDos.new(OPTS_NAM).domain_address.should == 'user'
      end
      it 'defaults from username and domain' do
        WinDos.new(OPTS_ALL).domain_address.should == "\\\\domain\\user"
      end
    end

    #---------------------------------------------------------------------
    describe '#expand_opts' do
      it 'creates from scratch' do
        WinDos.new(OPTS_ALL).expand_opts.should eql(OPTS_ALL)
      end
      it 'creates using passed' do
        WinDos.new(OPTS_ALL).expand_opts(EXTRA_OPTS.dup).should eql(OPTS_ALL.merge(EXTRA_OPTS))
      end
    end

    #---------------------------------------------------------------------
    describe '#collapse_opts' do
      before(:each) do
        @base = WinDos.new(OPTS_ALL)
      end
      it 'creates from scratch' do
        @opts = { :account => @base }
        @base.collapse_opts.should eql(@opts)
      end
      it 'creates using passed' do
        @opts = { :account => @base }.merge(EXTRA_OPTS)
        @base.collapse_opts(EXTRA_OPTS.dup).should eql(@opts)
      end
    end

  end

end
end end end
############################################################################
