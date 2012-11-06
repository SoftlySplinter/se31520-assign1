require 'fox16'

include Fox

class UserView < FXVerticalFrame
  def initialize(app, client, p, opts=0, x=0, y=0, width=0, height=0, padLeft=DEFAULT_SPACING, padRight=DEFAULT_SPACING, padTop=DEFAULT_SPACING, padBottom=DEFAULT_SPACING, hSpacing=DEFAULT_SPACING, vSpacing=DEFAULT_SPACING) # :yields: theVerticalFrame
    super(p, opts, x, y, width, height, padLeft, padRight, padTop, padBottom, hSpacing, vSpacing)
    @client = client
    @app = app
    @titleFont = FXFont.new(@app, "helvetica", 20, FXFont::Bold)

    self.setup
  end

  def setup
    FXLabel.new(self, "Users").font=@titleFont
    #TODO
  end
end
