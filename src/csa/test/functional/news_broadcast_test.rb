require 'test_helper'

class NewsBroadcastTest < ActionMailer::TestCase
  test "send_news" do
    mail = NewsBroadcast.send_news
    assert_equal "Send news", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
