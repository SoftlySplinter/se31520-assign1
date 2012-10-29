require 'rest_client'

def login(url, username, password)
  sessionID = RestClient.post(url, :login => username, :password => password){ |response, request, result, &block|
     return response.cookies if response.cookies != nil
  }
  raise 'Failed to login'
end

id = login('http://localhost:3000/session', 'admin', 'taliesin')
puts id
