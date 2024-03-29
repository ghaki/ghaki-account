############################################################################
require 'highline'
require 'ghaki/account/errors'
require 'ghaki/account/syn_opts'

############################################################################
module Ghaki    #:nodoc:
module Account  #:nodoc:

module Password

  ######################################################################
  # SYNONYM OPTIONS
  ######################################################################
  extend SynOpts
  attr_syn_opts :password, :passwords

  # overrides autogenerated
  def opt_password opts
    val = Password.parse_opts( opts )
    self.passwords = val
  end

  ######################################################################
  # CONSTANTS
  ######################################################################
  ASK_PASSWORD_RETRY_MAX = 3

  ######################################################################
  # OBJECT METHODS
  ######################################################################

  def password
    @cur_password ||= _try_passwords.first
  end
  def passwords
    @all_passwords ||= []
  end

  def passwords= pass
    @cur_passwords = nil
    @all_passwords = if pass.nil? then [] else [pass].flatten end
  end
  alias_method :password=, :passwords=

  def reset_passwords
    @try_passwords = nil
    @bad_passwords = nil
    @cur_password = nil
  end
  def fail_password
    _bad_passwords.push _try_passwords.shift unless _try_passwords.empty?
  end
  def retry_password?
    !_try_passwords.empty?
  end

  def valid_password?
    !passwords.empty?
  end

  def failed_passwords?
    !_bad_passwords.empty?
  end

  def ask_password opts={}
    f_ques,r_ques = _password_prompt( opts ), nil
    (1..(opts[:retry_max] || ASK_PASSWORD_RETRY_MAX)).each do
      self.password = HighLine.new.ask( r_ques || f_ques ) do |q|
        q.echo = '*'
      end
      return self.password if valid_password?
      r_ques ||= '* TRY AGAIN * ' + f_ques
    end
    raise InvalidPasswordError, 'Invalid Password Specified'
  end

  protected

  def _try_passwords
    @try_passwords ||= self.passwords.clone
  end
  def _bad_passwords
    @bad_passwords ||= []
  end

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

end end end
