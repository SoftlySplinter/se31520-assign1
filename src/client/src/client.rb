require_relative 'models/user.rb'
require_relative 'models/broadcast.rb'

require 'parseconfig'
require 'active_resource'
require 'logger'

class Client
  CONFIG_FILE = './csa.conf'
  LOGGER = Logger.new(ParseConfig.new(CONFIG_FILE)['logfile'])
  def initialize(user=nil, password=nil)
    parser = ParseConfig.new(CONFIG_FILE)
    @site = parser['site']
    @user = user
    @password = password
    @error = nil
  end

  def login(user, password)
    @user = user
    @password = password
    return loggedIn
  end

  def logout
    @user = nil
    @password = nil
  end

  def getError
    return @error
  end

  def loggedIn
    User.site = @site
    User.user = @user
    User.password = @password
    user =  User.get(:current)
    return User.exists?(user["id"])
  rescue ActiveResource::UnauthorizedAccess
    @error = "User unauthorized."
    return false
  rescue ActiveResource::ClientError => e
    @error = e.message
    return false
  end

  def users(*parameters)
    User.site = @site
    User.user = @user
    User.password = @password

    return User.find(*parameters)
  rescue ActiveResource::UnauthorizedAccess
    return false
  rescue ActiveResource::ClientError => e
    @error = e.message
    return false
  end

  def broadcasts(*parameters)
    Broadcast.site = @site
    Broadcast.user = @user
    Broadcast.password = @password

    return Broadcast.find(*parameters)
  rescue ActiveResource::UnauthorizedAccess
    return false
  rescue ActiveResource::ClientError => e
    @error = e.message
    return false
  end
end
