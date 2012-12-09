require_relative 'models/user.rb'
require_relative 'models/broadcast.rb'

require 'parseconfig'
require 'active_resource'
require 'logger'

# Class to perform interaction with the Rails server.
class Client
  # Config file to use.
  CONFIG_FILE = './csa.conf'
  
  # Logger object which will log to the file defined in the logfile.
  LOGGER = Logger.new(ParseConfig.new(CONFIG_FILE)['logfile'])

  # Initialise using some of the config file.
  def initialize()
    # Load the site from the config.
    parser = ParseConfig.new(CONFIG_FILE)
    @site = parser['site']
    
    # Prepare the object with nil values.
    @user = nil
    @password = nil
    @error = nil
    @logged_in = false
    @is_admin = false

    User.site = @site
    User.logger = LOGGER

    Broadcast.site = @site
    Broadcast.logger = LOGGER
  end

  # Attempt to login to the system.
  def login(user, password)
    @user = user
    @password = password

    User.user = @user
    User.password = @password
    
    Broadcast.user = @user
    Broadcast.password = @password

    # Set cached variables to save a lot of REST requests.
    @logged_in = currentUserExists?
    @is_admin = checkIsAdmin?
    return @logged_in
  end

  # Perform a logout.
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

  # Get the current error message.
  def getError
    return @error
  end

  # true if the user is definitely logged into the CSA server.
  def loggedIn?
    return @logged_in
  end

  # true if the user is an admin user.
  def isAdmin?
    return @is_admin
  end

  # Check if the current user is an admin user.
  def checkIsAdmin?
    # Get the current user.
    user = User.get(:current)
    
    # An admin user is defined by their username being 'admin'.
    return user['login'] == 'admin'
  rescue ActiveResource::UnauthorizedAccess => e
    @error = e.message
    return false
  rescue  ActiveResource::ConnectionError => e
    @error = e.message
    return false
  rescue Errno::ECONNREFUSED => e
    @error = "Unable to connect to #{@site}"
    return false
  end

  # Check the user that we're trying to login with exists.
  def currentUserExists?
    # Get the current user.
    user =  User.get(:current)
    
    # Check it exists.
    return User.exists?(user["id"])
  rescue ActiveResource::UnauthorizedAccess
    @error = "User unauthorized."
    return false
  rescue ActiveResource::ClientError => e
    @error = e.message
    return false
  rescue  ActiveResource::ConnectionError => e
    @error = e.message
    return false
  rescue Errno::ECONNREFUSED => e
    @error = "Unable to connect to #{@site}"
    return false
  end

  # Get the current user.
  def currentUser
    user = User.get(:current)
    return User.find(user["id"])
  rescue ActiveResource::UnauthorizedAccess
    @error = "User unauthorized."
    return nil
  rescue ActiveResource::ClientError => e
    @error = e.message
    return nil
  rescue  ActiveResource::ConnectionError => e
    @error = e.message
    return nil
  rescue Errno::ECONNREFUSED => e
    @error = "Unable to connect to #{@site}"
    return nil
  end

  # Load a user or a set of users. See ActiveResource for more information.
  def users(*parameters)
    return User.find(*parameters)
  rescue ActiveResource::UnauthorizedAccess
    return nil
  rescue ActiveResource::ClientError => e
    @error = e.message
    return nil
  rescue  ActiveResource::ConnectionError => e
    @error = e.message
    return nil
  rescue Errno::ECONNREFUSED => e
    @error = "Unable to connect to #{@site}"
    return nil
  end

  # Load a broadcast or set of broadcasts. See ActiveResource for more information.
  def broadcasts(*parameters)
    return Broadcast.find(*parameters)
  rescue ActiveResource::UnauthorizedAccess
    return nil
  rescue ActiveResource::ClientError => e
    @error = e.message
    return nil
  rescue  ActiveResource::ConnectionError => e
    @error = e.message
    return nil
  rescue Errno::ECONNREFUSED => e
    @error = "Unable to connect to #{@site}"
    return nil
  end
end
