############################################################################
require 'ghaki/account/windos'

############################################################################
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
    # CLASS TESTS
    ########################################################################

    ########################################################################
    context 'class' do
      subject { WinDos }
      specify { subject.ancestors.should include(Base) }
      it { should respond_to :from_opts }
      it { should respond_to :purge_opts }
    end

    ########################################################################
    context 'class methods' do

      #---------------------------------------------------------------------
      describe '#from_opts' do
        it 'should accept separate' do
          acc = WinDos.from_opts(OPTS_ALL)
          acc.username.should == 'user'
          acc.userdomain.should == 'domain'
        end
        it 'should pass thru whole' do
          acc = WinDos.from_opts(OPTS_ALL)
          opts = { :account => acc }
          WinDos.from_opts(opts).should eql(acc)
        end
      end

      #---------------------------------------------------------------------
      describe '#purge_opts' do
        it 'should remove' do
          WinDos.purge_opts(OPTS_ALL.merge(EXTRA_OPTS)).should eql(EXTRA_OPTS)
        end
      end

    end

    ########################################################################
    # OBJECT TESTS
    ########################################################################
    context 'objects' do
      subject { WinDos.new }
      it { should respond_to :expand_opts }
      it { should respond_to :collapse_opts }
      it { should respond_to :to_s }
    end

    ########################################################################
    context 'object methods' do

      #---------------------------------------------------------------------
      describe '#to_s' do
        it 'should default user domain only' do
          WinDos.new(OPTS_DOM).to_s.should == "\\\\domain\\*"
        end
        it 'should default username only' do
          WinDos.new(OPTS_NAM).to_s.should == "\\\\*\\user"
        end
        it 'should default with username and domain' do
          WinDos.new(OPTS_ALL).to_s.should == "\\\\domain\\user"
        end
      end

      #---------------------------------------------------------------------
      describe '#domain_address' do
        it 'should accept domain address directly' do
          WinDos.new(OPTS_DAD).domain_address.should == "\\\\domain\\user"
        end
        it 'should default with username only' do
          WinDos.new(OPTS_NAM).domain_address.should == 'user'
        end
        it 'should default with username and domain' do
          WinDos.new(OPTS_ALL).domain_address.should == "\\\\domain\\user"
        end
      end

      #---------------------------------------------------------------------
      describe '#expand_opts' do
        it 'should make from scratch' do
          WinDos.new(OPTS_ALL).expand_opts.should eql(OPTS_ALL)
        end
        it 'should make using passed' do
          WinDos.new(OPTS_ALL).expand_opts(EXTRA_OPTS.dup).should eql(OPTS_ALL.merge(EXTRA_OPTS))
        end
      end

      #---------------------------------------------------------------------
      describe '#collapse_opts' do
        before(:each) do
          @base = WinDos.new(OPTS_ALL)
        end
        it 'should make from scratch' do
          @opts = { :account => @base }
          @base.collapse_opts.should eql(@opts)
        end
        it 'should make using passed' do
          @opts = { :account => @base }.merge(EXTRA_OPTS)
          @base.collapse_opts(EXTRA_OPTS.dup).should eql(@opts)
        end
      end

    end

  end
end end end
############################################################################
