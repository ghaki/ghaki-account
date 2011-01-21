############################################################################
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki module Account
  module DB_Name
    extend SynOpts

    ######################################################################
    attr_syn_opts :db_name, :database_name
    attr_accessor :db_name

    #---------------------------------------------------------------------
    def valid_db_name?
      return false if @db_name.nil?
      return false if @db_name.empty?
      return true
    end

  end # helper
end end # package
############################################################################
