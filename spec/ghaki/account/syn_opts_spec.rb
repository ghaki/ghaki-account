############################################################################
require 'ghaki/account/syn_opts'
require File.join(File.dirname(__FILE__),'syn_opts_helper')

############################################################################
module Ghaki module Account

  ##########################################################################
  module UsingExtend
    extend SynOpts
    attr_syn_opts :foo, :bar
    attr_accessor :foo
  end

  ##########################################################################
  module SynOptsTesting
  describe SynOpts do

    ########################################################################
    extend SynOptsHelper
    syn_opts_test_declare UsingExtend, :foo, 'fubar', :bar

    ########################################################################
    # CLASS TESTING
    ########################################################################
    context 'class' do
      syn_opts_test_class :foo
    end
    context 'class methods' do
      syn_opts_test_class_methods :foo
    end

    ########################################################################
    # OBJECT TESTING
    ########################################################################
    context 'object' do
      syn_opts_test_object :foo
      it { should respond_to :foo }
      it { should respond_to :foo= }
    end
    context 'object_methods' do
      syn_opts_test_object_methods :foo
    end

  end
end end end
############################################################################
