class UsersController < ApplicationController

  before_action :confirm_login, except: [:index, :welcome, :login, :login_form, :logout, :create, :email_confirmation, :email_confirmation_again, :resend_email, :forgot_password_form, :reset_password_confirmation, :reset_password]

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
      session[:email_confirmed] = authorised_user[:email_confirmed]
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


  def update
  end

  #GET update user fields form
  def update_form
    @user = User.find_by_id(session[:user_id])
  end


  #POST edit user fields
  def update
    @user = User.find_by_id(session[:user_id])

    #check password
    if !@user.authenticate(params[:password])
      flash[:error] = "Incorrect password"
      redirect_to(:action => "update_form")
      return
    end

    #update details
    _birth = Date.civil(params[:birth][:year].to_i, params[:birth][:month].to_i, params[:birth][:day].to_i)
    if @user.update_attributes(:password => params[:password], :email => params[:email], :first_name => params[:first_name], :mid_name => params[:mid_name], :last_name => params[:last_name], :birth => _birth)
      flash[:notice] = "Details updated successfully. "
      redirect_to(:action => "update_form")
    else
      flash[:error] = "Failed to update user:" + @user.errors.full_messages[0]
      redirect_to(:action => "update_form")
    end
  end


  def update_password
    @user = User.find_by_id(session[:user_id])

    if !(params[:password_old].present? && params[:password].present? && params[:password_confirmation].present?)
      flash[:error_password] = "Please fill all fields."
      redirect_to(:action => "update_form")
      return
    end

    #check old password
    if !@user.authenticate(params[:password_old])
      flash[:error_password] = "Old password incorrect."
      redirect_to(:action => "update_form")
      return
    end

    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    if @user.save
      flash[:notice_password] = "Password updated successfully."
      redirect_to(:action => "update_form")
    else
      flash[:error_password] = @user.errors.full_messages[0]
      redirect_to(:action => "update_form")
      return
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
      redirect_to(:action => "welcome")
      UserMailer.welcome_email(@user).deliver
    else
      flash[:notice] = @user.errors.full_messages[0]
      @user.terms = 0
      render('register_form')  
    end
  end

  def welcome
  end

  #GET email confirmation from emailed link
  def email_confirmation
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

  def email_confirmation_again
  end

  def resend_email
    @user = User.find_by_id(session[:user_id])

    if @user 
      UserMailer.welcome_email(@user).deliver
      flash[:notice] = "Confirmation email sent. Please check your email and follow instructions."
    else
      flash[:notice] = "User not found"
    end
  end


  #GET logout
  def logout
    session[:user_id] = nil
    session[:username] = nil
    session[:email_confirmed] = nil
    redirect_to('/login')
  end

  def forgot_password_form
  end

  def reset_password_confirmation
  end

  def reset_password
    if params[:username].present?
      @user = User.where(:username => params[:username]).first
    end
    if !@user && params[:email].present?
      @user = User.where(:email => params[:email]).first
    end

    if @user
      #found username or email
      @user.password = generate_password
      if @user.save
        #send email
        UserMailer.reset_password_email(@user).deliver
        render ("reset_password_confirmation")
        return
      else
        flash[:error] = "Can't update user password in db"
        render ("forgot_password_form")
        return
      end
    else
      flash[:error] = "Username or email address not found"
      render ("forgot_password_form")
      return
    end

  end

  private
  
  def register_permits
    params.require(:user).permit(:username, :password, :password_confirmation, :email, :email_confirmation, :first_name, :mid_name, :last_name, :terms, :birth, :captcha, :captcha_key)
  end


  def confirm_login
    if session[:user_id]
      if session[:email_confirmed] == false 
        redirect_to(:action => "email_confirmation_again")
        return false
      end
      return true
    else
      redirect_to(:action => "login_form")      
      return false
    end
  end

  def generate_password
    r=""
    chars = [*'0'..'9'] | [*'a'..'z'] | [*'A'..'Z'] | ['-','_']
    8.times {r +=  chars[rand(chars.size-1)] }
    r
  end

end
