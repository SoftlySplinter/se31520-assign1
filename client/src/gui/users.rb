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

    @header1 = FXHeader.new(self, 
      :opts => HEADER_BUTTON|HEADER_RESIZE|FRAME_RAISED|FRAME_THICK|LAYOUT_FILL_X)
    @header1.appendItem("Surname", nil, 150)
    @header1.appendItem("First name", nil, 150)
    @header1.appendItem("Email", nil, 150)
    @header1.appendItem("Grad Year", nil, 150)

    panes = FXHorizontalFrame.new(self,
      FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :padLeft => 0, :padRight => 0, :padTop => 0, :padBottom => 0,
      :hSpacing => 0, :vSpacing => 0)

    @lists = []
    @lists.push(FXList.new(panes, :opts => LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH|LIST_SINGLESELECT,   :width => 150))
    @lists.push(FXList.new(panes, :opts => LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH|LIST_SINGLESELECT,   :width => 150))
    @lists.push(FXList.new(panes, :opts => LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH|LIST_SINGLESELECT,   :width => 150))
    @lists.push(FXList.new(panes, :opts => LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH|LIST_SINGLESELECT,   :width => 150))
  end
  def hasPage
    data = @client.users(:all, :params => { :page => @curPage })
    return !data.empty?
  end

  def refresh()
    @curPage = 1
    for list in @lists do
      list.clearItems()
    end

    while self.hasPage do
      self.propagate(@client.users(:all, :params => { :page => @curPage }))
      @curPage += 1
    end
  end

  def propagate(data)
    for entry in data do
      @lists[0].appendItem(entry.surname)
      @lists[1].appendItem(entry.firstname)
      @lists[2].appendItem(entry.email)
      @lists[3].appendItem("#{entry.grad_year}")
    end
  end
end
