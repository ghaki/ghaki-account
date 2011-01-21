############################################################################
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki module Account
  module DB_Driver
    extend SynOpts

    ######################################################################
    attr_syn_opts :db_driver, :database_driver
    attr_accessor :db_driver

    #---------------------------------------------------------------------
    def valid_db_driver?
      return false if @db_driver.nil?
      return false if @db_driver.empty?
      return true
    end

  end # helper
end end # package
############################################################################
