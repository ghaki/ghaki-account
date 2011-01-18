############################################################################
require 'highline'
require 'ghaki/account/errors'
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki
  module Account
    module Hostname

      ######################################################################
      # SYNONYM OPTIONS
      ######################################################################
      extend SynOpts
      attr_syn_opts :hostname, :host_name, :host

      ######################################################################
      # CONSTANTS
      ######################################################################
      HOSTNAME_RETRY_MAX = 3

      ######################################################################
      # CLASS METHODS
      ######################################################################

      #---------------------------------------------------------------------
      def Hostname.get_env
        if ENV.has_key?('HOSTNAME')
          ENV['HOSTNAME']
        else
          require 'socket'
          Socket.gethostname
        end
      end

      ######################################################################
      # OBJECT METHODS
      ######################################################################
      attr_reader :hostname

      #---------------------------------------------------------------------
      def hostname= val
        case val
        when String
          @hostname = val.strip
        when :env
          @hostname = Hostname.get_env
        else
          @hostname = val
        end
      end

      #---------------------------------------------------------------------
      def valid_hostname?
        return false if @hostname.nil?
        return false if @hostname.empty?
        return false unless @hostname =~ %r{\A\S+\z}o
        return true
      end

      #---------------------------------------------------------------------
      def ask_hostname opts={}
        o_prompt,r_prompt = _hostname_prompt(opts), nil
        defval = opts[:default] || @hostname
        defval = Hostname.get_env if defval == :env
        (1 .. (opts[:retry_max] || HOSTNAME_RETRY_MAX) ).each do
          self.hostname = HighLine.new.ask( r_prompt||o_prompt ) do |q|
            q.echo = true
            q.default = defval unless defval.nil?
          end
          return @hostname if valid_hostname?
          r_prompt ||= '* TRY AGAIN * ' + o_prompt
        end
        raise InvalidHostnameError, "Invalid Hostname: #{@hostname}"
      end

      #=====================================================================
      protected
      #=====================================================================

      #---------------------------------------------------------------------
      def _hostname_prompt opts
        prompt = 'Hostname: '
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
