require_relative 'models/user.rb'
require_relative 'models/broadcast.rb'

require 'parseconfig'
require 'active_resource'



class Client
  CONFIG_FILE = './csa.conf'
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
    # FIXME Need a better way of checking if a user is logged in.
    
    self.getUser(2)
    return true if @user != nil
  rescue ActiveResource::UnauthorizedAccess
    @error = "User unauthorized."
    return false
  end

  def getUser(id)
    User.site = @site
    User.user = @user
    User.password = @password

    return User.find(id)
  end

  def getBroadcast(id)
    Broadcast.site = @site
    Broadcast.user = @user
    Broadcast.password = @password

    return Broadcast.find(id)
  end
end
