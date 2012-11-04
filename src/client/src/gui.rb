require_relative('client.rb')
require 'fox16'

include Fox

# Useful snippet from http://www.fxruby.org/examples/shutter.rb
class ShutterButton < FXButton
  def initialize(p, txt, ic=nil)
    super(p, txt, ic, :opts => BUTTON_TOOLBAR|TEXT_BELOW_ICON|FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT)
    self.backColor = p.backColor
    self.textColor = FXRGB(255, 255, 255)
  end
end

class GUI
  def initialize(client)
    @client = client

    @app = FXApp.new
    @window = FXMainWindow.new(@app, "CS-Alumni")
    
    self.setup
  end

  def setup()
    splitter = FXSplitter.new(@window, (LAYOUT_SIDE_TOP|LAYOUT_FILL_X|
      LAYOUT_FILL_Y|SPLITTER_TRACKING))

    shutter = FXShutter.new(splitter,
      :opts => FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :padding => 0, :hSpacing => 0, :vSpacing => 0, :width => 100)

    switcher = FXSwitcher.new(splitter,
      FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 0)

    self.setupSwitcher(switcher)
    self.setupShutter(shutter, switcher)
  end

  def setupSwitcher(switcher)
    self.createHomeSection(switcher)
    self.createJobsSection(switcher)
    FXLabel.new(switcher, "Profile")
    FXLabel.new(switcher, "Users")
    FXLabel.new(switcher, "Broadcasts")
  end

  def createHomeSection(switcher)
    home = FXVerticalFrame.new(switcher)
    title = FXFont.new(@app, "helvetica", 20, FXFont::Bold)
    FXLabel.new(home, "Welcome to CS-Alumni News").font=title
    FXLabel.new(home, "The is where the home page text will go.")
  end

  def createJobsSection(switcher)
    jobs = FXVerticalFrame.new(switcher)
    title = FXFont.new(@app, "helvetica", 20, FXFont::Bold)
    FXLabel.new(jobs, "Jobs").font=title
    FXLabel.new(jobs, "Placeholder for the jobs screen.")
  end

  def setupShutter(shutter, switcher)
    shutterItem = FXShutterItem.new(shutter, "Menu", nil, LAYOUT_FILL_Y)
    ShutterButton.new(shutterItem.content, "Home").connect(SEL_COMMAND) { switcher.current = 0 }
    jobsBut = ShutterButton.new(shutterItem.content, "Jobs")
    jobsBut.connect(SEL_COMMAND) { switcher.current = 1}

    profileBut = ShutterButton.new(shutterItem.content, "Profile")
    profileBut.connect(SEL_COMMAND) { switcher.current = 2}

    userBut = ShutterButton.new(shutterItem.content, "Users")
    userBut.connect(SEL_COMMAND) { switcher.current = 3}

    broadBut = ShutterButton.new(shutterItem.content, "Broadcasts")
    broadBut.connect(SEL_COMMAND) { switcher.current = 4}

    logBut = ShutterButton.new(shutterItem.content, "Login")
    logBut.connect(SEL_COMMAND) { 
      if @client.loggedIn
        if(FXMessageBox.question(@window, MBOX_YES_NO, "Logout Confirmation", "Are you sure you want to logout?") == MBOX_CLICKED_YES)
          @client.logout
          switcher.current = 0
          logBut.text = "Login"
        end
      else
        dialog = FXDialogBox.new(@window, "Login")
        userPane = FXHorizontalFrame.new(dialog)
        FXLabel.new(userPane, "Username:")
        userInput = FXTextField.new(userPane, 30)

        passFrame = FXHorizontalFrame.new(dialog)
        FXLabel.new(passFrame, "Password:")
        passInput = FXTextField.new(passFrame, 30, :opts => FXTextField::TEXTFIELD_PASSWD|FRAME_SUNKEN|FRAME_THICK)
        passInput.overstrike = true

        butFrame = FXHorizontalFrame.new(dialog)
        loginBut = FXButton.new(butFrame, "Login")
        loginBut.connect(SEL_COMMAND) {
          user = userInput.text
          password = passInput.text
          if @client.login(user, password) 
            logBut.text = "Logout"
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
    }

    self.enableForLogin(profileBut)
    self.enableForLogin(userBut)
    self.enableForLogin(broadBut)
  end
  
  def enableForLogin(button)
    button.connect(SEL_UPDATE) do |sender, sel, ptr|
       message = @client.loggedIn ? FXWindow::ID_ENABLE : FXWindow::ID_DISABLE
       sender.handle(@window, MKUINT(message, SEL_COMMAND), nil)
    end
  end

  def run()
    @app.create
    @window.show
    @window.maximize(false)
    @app.run
  end
end

client = Client.new()
gui = GUI.new(client)
gui.run
