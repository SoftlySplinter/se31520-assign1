require_relative 'models/user.rb'
require_relative 'models/broadcast.rb'

class Client
  def initialize(site=nil, user=nil, password=nil)
    @site = site
    @user = user
    @password = password
  end

  def site=(site)
    @site = site
  end

  def user=(user)
    @user = user
  end

  def user
    return @user
  end

  def password=(password)
    @password = password
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
