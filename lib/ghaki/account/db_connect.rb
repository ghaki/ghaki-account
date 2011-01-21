############################################################################
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki module Account
  module DB_Connect
    extend SynOpts

    #---------------------------------------------------------------------
    attr_syn_opts :db_connect,
      :db_connector, :database_connect, :database_connector
    attr_writer   :db_connect

    #---------------------------------------------------------------------
    def db_connect
      @db_connect ||= self.make_db_connect
    end

    #---------------------------------------------------------------------
    def valid_db_connect? 
      return false if @db_connect.nil?
      return false if @db_connect.empty?
      return true
    end
                     
    ######################################################################
    protected
    ######################################################################

    #---------------------------------------------------------------------
    def make_db_connect
      con = "dbi:#{@db_driver}:#{@db_name}"
      if @hostname.nil?
        con += ':localhost' unless @db_port.nil?
      else
        con += ':' + @hostname
      end
      con += ':' + @db_port.to_s unless @db_port.nil?
      con
    end

  end # class
end # namespace
end # package
############################################################################
