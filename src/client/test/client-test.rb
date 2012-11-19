require 'test/unit'
require_relative '../src/client.rb'


class ClientTest < Test::Unit::TestCase
  # Assumes the CSA application is running on localhost:3000

  def test_not_loggedin_no_user
    # If the client has no credentials.
    client = Client.new
    
    # Should not be logged in.
    assert(!client.loggedIn, 'Should not be logged in with no credentials.')

    # Should not be able to access Users when not logged in.
    assert(!client.users(:all), 'Should not be able to access users when not logged in.')

    # Should not be able to access broadcasts when not logged in.
    assert(!client.broadcasts(:all), 'Should not be able to access broadcasts when not logged in.')
  end

  def test_login_admin
    # If we provide valid admin credentials
    client = Client.new('admin','taliesin')

    # Client should be logged in.
    assert(client.loggedIn, 'Admin user should be logged in.')    

    # Should be able to access all Users when admin.
    assert(client.users(:all), 'Should be able to access users when admin.')

    # Should be able to access all broadcasts when admin.
    assert(client.broadcasts(:all), 'Should be able to access broadcasts when admin.')
  end

  def test_login_admin_wrong_credentials
    # If we provide a valid admin username, but not password
    client = Client.new('admin', 'asdf')

    # Should not be logged in.
    assert(!client.loggedIn, 'Should not be logged in with invalid credentials')

    # Access tested by test_not_loggedin
  end

  def test_login_normal_user
    # If we provide valid user credentials
    client = Client.new('cwl0', 'secret')

    # Client should be logged in
    assert(client.loggedIn, 'Regular user should be logged in.')

    # Should not be able to access Users when user.
    assert(!client.users(:all), 'Should not be able to access users when user.')

    # Should not be able to access broadcasts when user.
    assert(!client.broadcasts(:all), 'Should not be able to access broadcasts when user.')
  end

  def test_loging_normal_user_wrong_credentials
    # If we provide a valid user username, but not password
    client = Client.new('cwl0', 'test')

    # Client should not be logged in
    assert(!client.loggedIn, 'Should not be logged in with invalid credentials')

    # Access tested by test_not_loggedin
  end
end

