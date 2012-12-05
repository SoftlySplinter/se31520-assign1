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
    @logged_in = false
    @is_admin = false

    User.site = @site
    User.user = @user
    User.password = @password
    User.logger = LOGGER

    Broadcast.site = @site
    Broadcast.user = @user
    Broadcast.password = @password
    Broadcast.logger = LOGGER
  end

  def login(user, password)
    @user = user
    @password = password

    User.user = @user
    User.password = @password
    
    Broadcast.user = @user
    Broadcast.password = @password

    @logged_in = currentUserExists?
    @is_admin = checkIsAdmin?
    return @logged_in
  end

  def logout
    @user = nil
    @password = nil
    @logged_in = false
    @is_admin = false

    User.user = nil
    User.password = nil

    Broadcast.user = nil
    Broadcast.password = nil
  end

  def getError
    return @error
  end

  def loggedIn?
    return @logged_in
  end

  def isAdmin?
    return @is_admin
  end

  def checkIsAdmin?
    user = User.get(:current)
    return user['login'] == 'admin'
  rescue ActiveResource::UnauthorizedAccess => e
    @error = e.message
    return false
  end

  def currentUserExists?
    user =  User.get(:current)
    return User.exists?(user["id"])
  rescue ActiveResource::UnauthorizedAccess
    @error = "User unauthorized."
    return false
  rescue ActiveResource::ClientError => e
    @error = e.message
    return false
  end

  def currentUser
    user = User.get(:current)
    return User.find(user["id"])
  rescue ActiveResource::UnauthorizedAccess
    @error = "User unauthorized."
    return nil
  rescue ActiveResource::ClientError => e
    @error = e.message
    return nil
  end

  def users(*parameters)
    return User.find(*parameters)
  rescue ActiveResource::UnauthorizedAccess
    return nil
  rescue ActiveResource::ClientError => e
    @error = e.message
    return nil
  end

  def broadcasts(*parameters)
    return Broadcast.find(*parameters)
  rescue ActiveResource::UnauthorizedAccess
    return nil
  rescue ActiveResource::ClientError => e
    @error = e.message
    return nil
  end
end
