############################################################################
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki module Account
  module DB_Port
    extend SynOpts

    ######################################################################
    attr_syn_opts :db_port, :database_port
    attr_accessor :db_port

    #---------------------------------------------------------------------
    def valid_db_port?
      return true if @db_port.nil?
      return true if @db_port.to_s =~ %r{\A\d+\z}o
      return false
    end

  end # helper
end end # package
############################################################################
