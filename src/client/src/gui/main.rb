require_relative('../client.rb')
require_relative('login.rb')
require_relative('users.rb')
require_relative('broadcasts.rb')
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
    @titleFont = FXFont.new(@app, "helvetica", 20, FXFont::Bold)
    
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
    self.createProfileSection(switcher)
    UserView.new(@app, @client, switcher)
    BroadcastView.new(@app, @client, switcher)
  end

  def createHomeSection(switcher)
    home = FXVerticalFrame.new(switcher)
    FXLabel.new(home, "Welcome to CS-Alumni News").font=@titleFont
    FXLabel.new(home, "The is where the home page text will go.")
  end

  def createJobsSection(switcher)
    jobs = FXVerticalFrame.new(switcher)
    FXLabel.new(jobs, "Jobs").font=@titleFont
    FXLabel.new(jobs, "Placeholder for the jobs screen.")
  end

  def createProfileSection(switcher)
    profile = FXVerticalFrame.new(switcher)
    FXLabel.new(profile, "Profile").font=@titleFont
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
    puts Login.new(@client, @window).attachLogin(switcher, logBut)

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

