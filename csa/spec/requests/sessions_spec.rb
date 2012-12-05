require 'spec_helper'

describe "Sessions" do
  describe "Login to the CSA Server" do
    it "Has a button to the login form" do
      get '/home'
      response.status.should be(200)

      assert_select 'form', action: '/session/new' do
        assert_select 'input#login'
      end
    end

    it "Logs in using the login form." do
      user_detail = UserDetail.create!(login: 'test', password: 'test')
      get '/session/new'
      response.status.should be(200)

      assert_select 'form#auth', action: '/session' do
        assert_select 'input[name=?]', 'login'
        assert_select 'input[name=?]', 'password'
        assert_select 'input[name=?]', 'commit'
      end

      post '/session', login: user_detail.login, password: user_detail.password
      expect(response).to redirect_to('/home')

      get '/home'

      assert_select '.login-form p', text: "Welcome #{user_detail.login}"
    end

    it "Fails to login with incorrect details." do
      user_detail = UserDetail.create!(login: 'test', password: 'test')
      get '/session/new'
      response.status.should be(200)

      assert_select 'form#auth', action: '/session' do
        assert_select 'input[name=?]', 'login'
        assert_select 'input[name=?]', 'password'
        assert_select 'input[name=?]', 'commit'
      end

      post '/session', login: user_detail.login, password: 'incorrect'

      # Annoyingly we have to change the ' to a HTML encoded form here.
      assert_select '#flash', text: "#{I18n.t('sessions.login-failure')} #{user_detail.login}".sub('\'', '&#x27;')
    end
  end
end
