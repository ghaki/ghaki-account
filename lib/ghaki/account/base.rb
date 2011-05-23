############################################################################
require 'ghaki/account/hostname'
require 'ghaki/account/username'
require 'ghaki/account/password'
require 'ghaki/account/email_address'

module Ghaki   #:nodoc:
module Account #:nodoc:

class Base
  include Hostname
  include Username
  include Password
  include EMailAddress

  ######################################################################
  # CLASS METHODS
  ######################################################################

  def self.from_opts opts
    opts[:account] || Base.new(opts)
  end

  def self.purge_opts opts
    Hostname.purge_opts opts
    Username.purge_opts opts
    Password.purge_opts opts
    EMailAddress.purge_opts opts
    opts.delete(:account)
    opts
  end

  ######################################################################
  # OBJECT METHODS
  ######################################################################

  def initialize opts={}
    _from_opts opts
  end

  def expand_opts opts={}
    opts.delete(:account)
    opts[:hostname] = @hostname unless @hostname.nil?
    opts[:username] = @username unless @username.nil?
    opts[:password] = self.passwords unless passwords.empty?
    opts[:email_address] = @email_address unless @email_address.nil?
    opts
  end

  def collapse_opts opts={}
    self.class.purge_opts opts
    opts[:account] = self
    opts
  end

  def to_s
    (@username || '*') + '@' + (@hostname || '*')
  end

  def ask_all opts={}
    ask_hostname opts[:hostname_opts] || {}
    ask_username opts[:username_opts] || {}
    ask_password opts[:password_opts] || {}
  end

  ######################################################################
  protected
  ######################################################################

  def _from_opts opts
    opt_hostname opts
    opt_username opts
    opt_password opts
    opt_email_address opts
  end

end
end end
