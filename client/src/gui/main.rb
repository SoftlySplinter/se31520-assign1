require_relative('../client.rb')
require_relative('login.rb')
require_relative('users.rb')
require_relative('broadcasts.rb')
require_relative('profile.rb')
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

# The main GUI Class.
class GUI
  def initialize(client)
    @client = client

    @app = FXApp.new
    @window = FXMainWindow.new(@app, "CS-Alumni")
    @titleFont = FXFont.new(@app, "helvetica", 20, FXFont::Bold)
    
    self.setup
  end

  # Set up the GUI.
  def setup()
    # Window splitter.
    splitter = FXSplitter.new(@window, (LAYOUT_SIDE_TOP|LAYOUT_FILL_X|
      LAYOUT_FILL_Y|SPLITTER_TRACKING))

    # Shutter down the LHS
    shutter = FXShutter.new(splitter,
      :opts => FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :padding => 0, :hSpacing => 0, :vSpacing => 0, :width => 100)

    # Window switcher on the RHS
    switcher = FXSwitcher.new(splitter,
      FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 0)

    # Setup up both of the above.
    self.setupSwitcher(switcher)
    self.setupShutter(shutter, switcher)
  end

  # Set up the page switcher.
  def setupSwitcher(switcher)
    # Create the blank sections.
    self.createHomeSection(switcher)
    self.createJobsSection(switcher)

    # Create objects for the proper views.
    @profileView = ProfileView.new(@app, @client, switcher)
    @userView = UserView.new(@app, @client, switcher)
    @broadcastView = BroadcastView.new(@app, @client, switcher)
  end

  # Builds the home section, just displays text.
  def createHomeSection(switcher)
    home = FXVerticalFrame.new(switcher)
    FXLabel.new(home, "Welcome to CS-Alumni News").font=@titleFont
    FXLabel.new(home, "The is where the home page text will go.")
  end

  # Builds the jobs section (which does nothing as of yet).
  def createJobsSection(switcher)
    jobs = FXVerticalFrame.new(switcher)
    FXLabel.new(jobs, "Jobs").font=@titleFont
    FXLabel.new(jobs, "Placeholder for the jobs screen.")
  end

  # Set up the menu shutter.
  def setupShutter(shutter, switcher)
    shutterItem = FXShutterItem.new(shutter, "Menu", nil, LAYOUT_FILL_Y)
    ShutterButton.new(shutterItem.content, "Home").connect(SEL_COMMAND) { switcher.current = 0 }
    jobsBut = ShutterButton.new(shutterItem.content, "Jobs")
    jobsBut.connect(SEL_COMMAND) { switcher.current = 1}

    profileBut = ShutterButton.new(shutterItem.content, "Profile")
    profileBut.connect(SEL_COMMAND) { 
      switcher.current = 2
      @profileView.refresh
    }

    userBut = ShutterButton.new(shutterItem.content, "Users")
    userBut.connect(SEL_COMMAND) { 
      switcher.current = 3
      @userView.refresh
    }

    broadBut = ShutterButton.new(shutterItem.content, "Broadcasts")
    broadBut.connect(SEL_COMMAND) { 
      switcher.current = 4
      @broadcastView.refresh
    }

    logBut = ShutterButton.new(shutterItem.content, "Login")
    puts Login.new(@client, @window).attachLogin(switcher, logBut)

    self.enableForLogin(profileBut)
    self.enableForLoginAndAdmin(userBut)
    self.enableForLoginAndAdmin(broadBut)
  end

  # Set up triggers for enabling buttons on login.  
  def enableForLogin(button)
    button.connect(SEL_UPDATE) do |sender, sel, ptr|
       message = @client.loggedIn? ? FXWindow::ID_ENABLE : FXWindow::ID_DISABLE
       sender.handle(@window, MKUINT(message, SEL_COMMAND), nil)
    end
  end


  # Set up triggers for enabling buttons on login of an admin user.
  def enableForLoginAndAdmin(button)
    button.connect(SEL_UPDATE) do |sender, sel, ptr|
       message = @client.loggedIn? && @client.isAdmin? ? FXWindow::ID_ENABLE : FXWindow::ID_DISABLE
       sender.handle(@window, MKUINT(message, SEL_COMMAND), nil)
    end
  end

  # Run the GUI.
  def run()
    @app.create
    @window.show
    @window.maximize(false)
    @app.run
  end
end

