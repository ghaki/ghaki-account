############################################################################
require 'etc'
require 'highline'
require 'ghaki/account/errors'
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki
  module Account
    module Username

      ######################################################################
      extend SynOpts
      attr_syn_opts :username, :user_name, :user

      ######################################################################
      # CONSTANTS
      ######################################################################
      USERNAME_RETRY_MAX = 3

      ######################################################################
      # CLASS METHODS
      ######################################################################

      #---------------------------------------------------------------------
      def Username.get_env
        Etc.getlogin
      end

      ######################################################################
      # OBJECT METHODS
      ######################################################################
      attr_reader :username

      #---------------------------------------------------------------------
      def username= val
        case val
        when String
          @username = val.strip
        when :env
          @username = Username.get_env
        else
          @username = val
        end
      end

      #---------------------------------------------------------------------
      def valid_username?
        return false if @username.nil?
        return false if @username.empty?
        return false unless @username =~ %r{\A\S+\z}o
        return true
      end

      #---------------------------------------------------------------------
      def ask_username opts={}
        f_ques,r_ques = _username_prompt(opts), nil
        defval = opts[:default] || @username
        defval = Username.get_env if defval == :env
        (1 .. (opts[:retry_max] || USERNAME_RETRY_MAX) ).each do
          @username = HighLine.new.ask( r_ques || f_ques ) do |q|
            q.echo = true
            q.default = defval unless defval.nil?
          end
          return @username if valid_username?
          r_ques ||= '* TRY AGAIN * ' + f_ques
        end
        raise InvalidUsernameError, "Invalid Username: #{@username}"
      end

      ######################################################################
      protected
      ######################################################################

      #---------------------------------------------------------------------
      def _username_prompt opts
        prompt = 'Username: '
        case opts[:prompt]
        when nil, :default
        when :auto
          unless @hostname.nil?
            '(' + @hostname + ') ' + prompt
          end
        else
          prompt = opts[:prompt]
        end
        prompt
      end

    end # helper
  end # namespace
end # package
############################################################################
