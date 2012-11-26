require 'fox16'

include Fox

class ProfileView < FXVerticalFrame
  def initialize(app, client, p, opts=0, x=0, y=0, width=0, height=0, padLeft=DEFAULT_SPACING, padRight=DEFAULT_SPACING, padTop=DEFAULT_SPACING, padBottom=DEFAULT_SPACING, hSpacing=DEFAULT_SPACING, vSpacing=DEFAULT_SPACING) # :yields: theVerticalFrame
    super(p, opts, x, y, width, height, padLeft, padRight, padTop, padBottom, hSpacing, vSpacing)
    @client = client
    @app = app
    @titleFont = FXFont.new(@app, "helvetica", 20, FXFont::Bold)
    @user = nil

    self.setup
  end

  def setup
    FXLabel.new(self, "Profile").font=@titleFont

    matrix = FXMatrix.new(self, 2, MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    
    FXLabel.new(matrix, 'First Name:')
    @firstname = FXTextField.new(matrix, 25)

    FXLabel.new(matrix, 'Surname:')
    @surname = FXTextField.new(matrix, 25)

    FXLabel.new(matrix, 'e-mail:')
    @email = FXTextField.new(matrix, 25)

    FXLabel.new(matrix, 'Phone:')
    @phone = FXTextField.new(matrix, 25)

    FXLabel.new(matrix, 'Grad. Year:')
    @grad = FXTextField.new(matrix, 25)

    FXLabel.new(matrix, 'Jobs:')
    @jobs = FXCheckButton.new(matrix, nil)

    FXLabel.new(matrix, nil)
    FXButton.new(matrix, 'Update')

  end

  def user=(user)
    @user = user
  end

  def refresh()
    @user = @client.currentUser if @client.currentUserExists?
    @firstname.text = @user.firstname
    @surname.text = @user.surname
    @email.text = @user.email
    @phone.text = "#{@user.phone}"
    @grad.text = "#{@user.grad_year}"
    state = @user.jobs ? TRUE : FALSE
    @jobs.setCheck(state, false)
  end
end
