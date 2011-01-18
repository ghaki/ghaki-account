############################################################################
require 'highline'
require 'ghaki/account/errors'
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki
  module Account
    module UserDomain

      ######################################################################
      extend SynOpts
      attr_syn_opts :userdomain, :user_domain

      ######################################################################
      # CONSTANTS
      ######################################################################
      USERDOMAIN_RETRY_MAX = 3

      ######################################################################
      # CLASS METHODS
      ######################################################################

      #---------------------------------------------------------------------
      def UserDomain.get_env
        ENV['USERDOMAIN']
      end

      ######################################################################
      # OBJECT METHODS
      ######################################################################
      attr_reader :userdomain

      #---------------------------------------------------------------------
      def userdomain= val
        case val
        when :env
          @userdomain = UserDomain.get_env
        when String
          @userdomain = val.strip
        else
          @userdomain = val
        end
      end

      #---------------------------------------------------------------------
      def valid_userdomain?
        return false if @userdomain.nil?
        return false if @userdomain.empty?
        return false unless @userdomain =~ %r{\A\w+\z}o
        return true
      end

      #---------------------------------------------------------------------
      def ask_userdomain opts={}
        o_prompt,r_prompt = _userdomain_prompt(opts), nil
        defval = opts[:default] || @userdomain
        defval = UserDomain.get_env if defval == :env
        (1 .. (opts[:retry_max] || USERDOMAIN_RETRY_MAX) ).each do
          self.userdomain = HighLine.new.ask( r_prompt||o_prompt ) do |q|
            q.echo = true
            q.default = defval unless defval.nil?
          end
          return @userdomain if valid_userdomain?
          r_prompt ||= '* TRY AGAIN * ' + o_prompt
        end
        raise InvalidUserDomainError, "Invalid User Domain: #{@userdomain}"
      end

      ######################################################################
      protected
      ######################################################################

      #---------------------------------------------------------------------
      def _userdomain_prompt opts
        prompt = 'User Domain: '
        case opts[:prompt]
        when nil, :default, :auto
        else
          prompt = opts[:prompt]
        end
        prompt
      end

    end # class
  end # namespace
end # package
############################################################################
