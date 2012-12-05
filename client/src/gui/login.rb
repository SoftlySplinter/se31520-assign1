require_relative('../client.rb')
require 'fox16'

include Fox

class Login
  def initialize(client, window)
    @client = client
    @window = window
  end

  # Attach login functionality to a button
  def attachLogin(switcher, button)
    button.connect(SEL_COMMAND) { 
      if @client.loggedIn?
        if(FXMessageBox.question(@window, MBOX_YES_NO, "Logout Confirmation", "Are you sure you want to logout?") == MBOX_CLICKED_YES)
          @client.logout
          switcher.current = 0
          button.text = "Login"
        end
      else
        self.doLogin(button)
      end
    }
  end

  # Create a dialog for logging into the CSA Client.
  def doLogin(button)
    dialog = FXDialogBox.new(@window, "Login")
    userPane = FXHorizontalFrame.new(dialog)
    FXLabel.new(userPane, "Username:")
    userInput = FXTextField.new(userPane, 30)
    passFrame = FXHorizontalFrame.new(dialog)
    FXLabel.new(passFrame, "Password:")
    passInput = FXTextField.new(passFrame, 30, :opts => FXTextField::TEXTFIELD_PASSWD|FRAME_SUNKEN|FRAME_THICK)

    butFrame = FXHorizontalFrame.new(dialog)
    loginBut = FXButton.new(butFrame, "Login")

    loginBut.connect(SEL_COMMAND) {
      user = userInput.text
      password = passInput.text
      if @client.login(user, password) 
        button.text = "Logout"
        # Send ID_ACCEPT to the dialog as everything's worked as expected
        dialog.handle(@window, MKUINT(FXDialogBox::ID_ACCEPT, SEL_COMMAND), nil)
      else
        FXMessageBox.warning(dialog, FXMessageBox::MBOX_OK, "Unable to login", @client.getError)
      end
    }
    
    cancelBut = FXButton.new(butFrame, "Cancel")
    cancelBut.connect(SEL_COMMAND) {
      dialog.handle(@window, MKUINT(FXDialogBox::ID_CANCEL, SEL_COMMAND), nil)
    }
    dialog.execute()
  end
end
