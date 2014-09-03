class UsersController < ApplicationController
  def index
    @user = User.new
    flash[:notice] = ""
    render('register_form')
  end

  def login_form
  end

  def edit_form
  end

  def create
    # puts '**************************************'
    # puts params.inspect
    @user = User.new(permits)

    # puts "Params:"
    # puts permits.inspect
    
    # puts "User:"
    # puts @user.inspect

    # puts "CAPTCHA: "
    # puts simple_captcha_valid?
    
    # puts '**************************************'

    if !simple_captcha_valid? 
      flash[:notice] = "Captcha validation does not match"
      @user.terms = 0
      render('register_form')
      return
    end

    if @user.save
      flash[:notice] = ""
      render inline: "User Created"
      #redirect_to('users')
      
    else
      flash[:notice] = @user.errors.full_messages[0]
      @user.terms = 0
      render('register_form')  
    end
  
  end

  private
  
  def permits
    puts params[:birth]
    params.require(:user).permit(:username, :password, :password_confirmation, :email, :first_name, :mid_name, :last_name, :terms, :birth, :captcha, :captcha_key)
  end

end
