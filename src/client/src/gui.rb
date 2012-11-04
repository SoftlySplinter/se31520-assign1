require_relative('client.rb')
require 'fox16'

include Fox

class GUI
  def initialize(client)
    @client = client

    @app = FXApp.new
    @window = FXMainWindow.new(@app, "CSA Client")
    
    self.setup
  end

  def setup()
    splitter = FXSplitter.new(@window, (LAYOUT_SIDE_TOP|LAYOUT_FILL_X|
      LAYOUT_FILL_Y|SPLITTER_TRACKING))

    shutter = FXShutter.new(splitter,
      :opts => FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :padding => 0, :hSpacing => 0, :vSpacing => 0)

    @switcher = FXSwitcher.new(splitter,
      FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 0)

    FXLabel.new(@switcher, "Test")
    FXLabel.new(@switcher, "Page 2")
    
    shutterItem = FXShutterItem.new(shutter, "Menu", nil, LAYOUT_FILL_Y)
    FXButton.new(shutterItem.content, "Home").connect(SEL_COMMAND) { @switcher.current = 0 }
    FXButton.new(shutterItem.content, "Page 2").connect(SEL_COMMAND) { @switcher.current = 1}
  end

  def run()
    @app.create
    @window.show
    @app.run
  end
end

class LoginScreen < FXComposite
  def initialize(parent, client, opts=0, x=0, y=0, width=50, height=50)
    super(parent, opts, x, y, width, height)
    @client = client
    self.setup
    self.show
  end

  def setup
    username = FXTextField.new(self, 30)
    password = FXTextField.new(self, 30)
    login = FXButton.new(self, "Login")
    login.connect(SEL_COMMAND) do |sender, selector, data|
      @client.user = username.text
      @client.password = password.text
    end
  end
end

client = Client.new()
gui = GUI.new(client)
gui.run
