require 'test_helper'

class NewsBroadcastTest < ActionMailer::TestCase
  setup do
    @user = users(:one)
    @broadcast = broadcasts(:one)
  end

  test "send_news" do
    mail = NewsBroadcast.send_news(@user, @broadcast, 'Test')
    assert_equal "Aber CS Test News", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["adb9@aber.ac.uk"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
