class UsersController < ApplicationController

  before_action :confirm_login, except: [:index, :login, :login_form, :edit_form, :create, :email_confirmation]

  #-> register_form view
  def index
    if session[:user_id].present? 
      redirect_to(:action => "control_panel") 
      return
    end
    @user = User.new
    flash[:notice] = ""
    render('register_form')
  end

  def login_form
    if session[:user_id].present? 
      redirect_to(:action => "control_panel") 
      return
    end
  end

  #POST login attempt
  def login
    if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first
      if found_user
        authorised_user = found_user.authenticate(params[:password])
      end
    end

    if authorised_user
      session[:user_id] = authorised_user.id
      session[:username] = authorised_user.username
      #render inline: "IN"
      redirect_to(:action=>"control_panel")
    else
      flash[:error] = "Invalid username/password"
      render("login_form")
    end
  end

  #GET users/control_panel
  def control_panel
  end

  #GET login check
  def edit_form
    if confirm_login
      render inline: "You are logged in"
    end
  end

  #POST create new user
  def create
    @user = User.new(register_permits)

    if !simple_captcha_valid? 
      flash[:notice] = "Captcha validation does not match"
      @user.terms = 0
      render('register_form')
      return
    end

    if @user.save
      flash[:notice] = ""
      render inline: "User Created"
      UserMailer.welcome_email(@user).deliver
    else
      flash[:notice] = @user.errors.full_messages[0]
      @user.terms = 0
      render('register_form')  
    end
  end

  #GET email confirmation from emailed link
  def email_confirmation
    flash[:error] = ":"
    @user = User.where(:username => params[:username]).first

    #checking if email is already confirmed:
    if @user.email_confirmed == true then return end
      
    #checking if confirmation id is the same as in DB:
    if @user.email_confirmation_id == params[:id] 
      
      #updating email_confirmed in DB:
      if @user.update_columns(:email_confirmed => true) == false 
        
        flash[:error] += " Error updating db. " 
      else
        @user.email_confirmed = true         
      end
    end
    
  end

  #GET logout
  def logout
    session[:user_id] = nil
    session[:username] = nil
    redirect_to('/login')
  end


  private
  
  def register_permits
    params.require(:user).permit(:username, :password, :password_confirmation, :email, :first_name, :mid_name, :last_name, :terms, :birth, :captcha, :captcha_key)
  end

  def confirm_login
    if session[:user_id]
      return true
    else
      redirect_to(:action => "login_form")      
      return false
    end
  end

end
