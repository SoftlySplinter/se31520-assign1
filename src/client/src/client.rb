require_relative 'models/user.rb'
require_relative 'models/broadcast.rb'

class Client
  def initialize(site="http://localhost:3000", user=nil, password=nil)
    @site = site
    @user = user
    @password = password
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

  def loggedIn
    # FIXME Need a better way of checking if a user is logged in.
    return true if @user != nil
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
