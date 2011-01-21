############################################################################
require 'ghaki/account/base'
require 'ghaki/account/db_name'
require 'ghaki/account/db_port'
require 'ghaki/account/db_driver'
require 'ghaki/account/db_connect'

############################################################################
module Ghaki module Account
  class Database < Base
    include DB_Name
    include DB_Port
    include DB_Driver
    include DB_Connect

    ######################################################################
    # CLASS METHODS
    ######################################################################

    #---------------------------------------------------------------------
    def self.from_opts opts
      opts[:account] || Database.new(opts)
    end

    #---------------------------------------------------------------------
    def self.purge_opts opts ; super opts
      DB_Name.purge_opts opts
      DB_Port.purge_opts opts
      DB_Driver.purge_opts opts
      DB_Connect.purge_opts opts
      opts
    end

    ######################################################################
    # OBJECT METHODS
    ######################################################################

    #---------------------------------------------------------------------
    def expand_opts opts={} ; super opts
      opts[:db_name]    = @db_name    unless @db_name.nil?
      opts[:db_port]    = @db_port    unless @db_port.nil?
      opts[:db_driver]  = @db_driver  unless @db_driver.nil?
      opts[:db_connect] = @db_connect unless @db_connect.nil?
      opts
    end

    #---------------------------------------------------------------------
    def to_s
      @db_name + ':' + (@username || '*') + '@' + (@hostname || 'localhost')
    end

    ######################################################################
    protected
    ######################################################################

    #---------------------------------------------------------------------
    def _from_opts opts ; super opts
      opt_db_name    opts
      opt_db_port    opts
      opt_db_driver  opts
      opt_db_connect opts
    end

  end # class
end end # package
############################################################################
