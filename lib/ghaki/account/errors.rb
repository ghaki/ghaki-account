module Ghaki
  module Account

    class InvalidHostnameError < RuntimeError; end
    class InvalidPasswordError < RuntimeError; end
    class InvalidUsernameError < RuntimeError; end
    class InvalidUserDomainError < RuntimeError; end

  end
end 
