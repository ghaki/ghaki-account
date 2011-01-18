############################################################################
require 'ghaki/account/base'
require 'ghaki/account/userdomain'
require 'ghaki/account/domain_address'

############################################################################
module Ghaki
  module Account
    class WinDos < Base
      include UserDomain
      include DomainAddress

      ######################################################################
      # CLASS METHODS
      ######################################################################

      #---------------------------------------------------------------------
      def self.from_opts opts
        opts[:account] || WinDos.new(opts)
      end

      #---------------------------------------------------------------------
      def self.purge_opts opts ; super opts
        UserDomain.purge_opts opts
        DomainAddress.purge_opts opts
        opts
      end

      ######################################################################
      # OBJECT METHODS
      ######################################################################

      #---------------------------------------------------------------------
      def expand_opts opts={} ; super opts
        opts[:userdomain]     = @userdomain     unless @userdomain.nil?
        opts[:domain_address] = @domain_address unless @domain_address.nil?
        opts
      end

      #---------------------------------------------------------------------
      def to_s
        "\\\\" + (@userdomain || '*') + "\\" + (@username || '*')
      end

      ######################################################################
      protected
      ######################################################################

      #---------------------------------------------------------------------
      def _from_opts opts ; super opts
        opt_userdomain opts
        opt_domain_address opts
      end

    end # class
  end # namespace
end # package
############################################################################
