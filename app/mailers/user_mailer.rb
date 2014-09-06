class UserMailer < ActionMailer::Base
  default from: "welcome@gmail.com"

  def welcome_email(user)
    puts '*********************** MAILER. Sending to #{@user.email} ****************************************'
    @user = user
    @url = 'http://test.com/l'
    mail(to: @user.email, subject: "Welcome to blogapp.com Site")
  end

  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: "blogapp.com, password reset")
  end
end
