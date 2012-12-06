require 'spec_helper'

# Sessions testing.
describe "Sessions" do
  describe "Login to the CSA Server" do
  
    it "Has a button to the login form" do
      # Go to the home page
      get '/home'
      response.status.should be(200)

      # Find the form with the button to go to the login page.
      assert_select 'form', action: '/session/new' do
        assert_select 'input#login'
      end
    end

    it "Logs in using the login form." do
      # Create a user detail.
      user_detail = UserDetail.create!(login: 'test', password: 'test')
      
      # Go to the login page.
      get '/session/new'
      response.status.should be(200)

      # Find the login form.
      assert_select 'form#auth', action: '/session' do
        assert_select 'input[name=?]', 'login'
        assert_select 'input[name=?]', 'password'
        assert_select 'input[name=?]', 'commit'
      end

      # Post to the action the form performs.
      post '/session', login: user_detail.login, password: user_detail.password
      
      # As the information is correct we expect to be redirected to the home page.
      expect(response).to redirect_to('/home')

      # To check everything is correct go to the home page and see if the application has registred the login.
      get '/home'
      assert_select '.login-form p', text: "Welcome #{user_detail.login}"
    end

    it "Fails to login with incorrect details." do
      # Create the user.
      user = User.find(2)
      user_detail = UserDetail.create(login: 'test', password: 'test', user: user)
      
      # Go to the login page.
      get '/session/new'
      response.status.should be(200)

      # Find the login form.
      assert_select 'form#auth', action: '/session' do
        assert_select 'input[name=?]', 'login'
        assert_select 'input[name=?]', 'password'
        assert_select 'input[name=?]', 'commit'
      end

      # Post to the action of the login form with incorrect details.
      post '/session', login: user_detail.login, password: 'incorrect'

      # Check there's a flash message for that says the user wasn't logged in.
      # Annoyingly we have to change the ' to a HTML encoded form here.
      assert_select '#flash', text: "#{I18n.t('sessions.login-failure')} #{user_detail.login}".sub('\'', '&#x27;')
    end

    it "Can access it's own profile." do
      # Create the user.
      user = User.find(2)
      user_detail = UserDetail.create(login: 'test', password: 'test', user: user)

      # Login. We know this works from earilier tests.
      post '/session', login:user_detail.login, password: user_detail.password
      get '/home'      

      # Check the profile link exists
      assert_select '#profile' do
        assert_select 'a', href: "/users/#{user_detail.user_id}"
      end

      get "/users/#{user_detail.user_id}"
      response.status.should be(200)
      
      assert_select 'h1', content: "#{user.firstname} #{user.surname}"
    end

    it "Cannot access any other profile." do
      user = User.find(1)
      user_detail = UserDetail.create!(login: 'test', password: 'test')

      # Login. We know this works from earilier tests.
      post '/session', login:user_detail.login, password: user_detail.password
      get "/users/#{user.id}"
      expect(response).to redirect_to('/home')
    end
  end
end
