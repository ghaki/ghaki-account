############################################################################
require 'singleton'

############################################################################
module Ghaki module Account module SynOptsHelper

  class SynOptsHolder < Hash
    include Singleton
  end

  ##########################################################################
  class SynOptsTester
    attr_accessor :parent, :child,
      :source, :target, :value, :names
  end

  ##########################################################################
  def syn_opts_test_declare kparent, source, value, *names
    test = SynOptsHolder.instance[source] = SynOptsTester.new
    test.parent = kparent
    test.child = Class.new
    test.child.class_eval do
      include kparent
    end
    test.source = source
    test.value = value
    test.names = names
    test.names << source
    test.target = ('opt_' + source.to_s).to_sym
  end

  ##########################################################################
  def syn_opts_test_class source
    test = SynOptsHolder.instance[source]
    subject { test.parent }
    it { should respond_to :parse_opts }
    it { should respond_to :purge_opts }
  end

  ##########################################################################
  def syn_opts_test_object source
    test = SynOptsHolder.instance[source]
    subject { test.child.new }
    it { should respond_to test.target }
  end

  ##########################################################################
  def syn_opts_test_class_methods source
    test = SynOptsHolder.instance[source]
    subject { test.parent }

    describe '#parse_opts' do
      test.names.each do |name|
        it "should accept option <#{name}>" do
          subject.parse_opts( { name => test.value } ).should == test.value
        end
      end
      it 'should accept account value' do
        account = mock()
        account.expects(test.source).returns(test.value)
        subject.parse_opts( { :account => account } ).should == test.value
      end
    end

    describe '#purge_opts' do
      test.names.each do |name|
        it "should remove option <#{name}>" do
          subject.purge_opts( { name => test.value } ).should eql({})
        end
      end
    end

  end

  ##########################################################################
  def syn_opts_test_object_methods source
    test = SynOptsHolder.instance[source]
    subject { test.child.new }
    describe "##{test.target}" do
      test.names.each do |name|
        it "should accept option <#{name}>" do
          subject.send( test.target, { name => test.value } )
          subject.send( test.source ).should == test.value
        end
      end
    end
  end

end end end
############################################################################
