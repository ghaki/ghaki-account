############################################################################
require 'highline'
require 'ghaki/account/errors'
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki
  module Account
    module Password

      ######################################################################
      # SYNONYM OPTIONS
      ######################################################################
      extend SynOpts
      attr_syn_opts :password

      ######################################################################
      # CONSTANTS
      ######################################################################
      PASSWORD_RETRY_MAX = 3

      ######################################################################
      # OBJECT METHODS
      ######################################################################
      attr_accessor :password

      #---------------------------------------------------------------------
      def valid_password?
        ! @password.nil?
      end

      #---------------------------------------------------------------------
      def ask_password opts={}
        f_ques,r_ques = _password_prompt( opts ), nil
        (1..(opts[:retry_max] || PASSWORD_RETRY_MAX)).each do
          @password = HighLine.new.ask( r_ques || f_ques ) do |q|
            q.echo = '*'
          end
          return @password if valid_password?
          r_ques ||= '* TRY AGAIN * ' + f_ques
        end
        raise InvalidPasswordError, 'Invalid Password Specified'
      end

      protected

      #---------------------------------------------------------------------
      def _password_prompt opts
        prompt = 'Password: '
        case opts[:prompt]
        when nil, :default
        when :auto
          unless @username.nil? and @hostname.nil?
            prompt = '(' + (@username || '*') +
              '@' + (@hostname || '*') +
              ') ' + prompt
          end
        end
        prompt
      end

    end # helper
  end # namespace
end # package
############################################################################
