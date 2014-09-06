class UserMailer < ActionMailer::Base
  default from: "welcome@gmail.com"

  def welcome_email(user)
    puts '*********************** MAILER. Sending to #{@user.email} ****************************************'
    @user = user
    @url = 'http://test.com/l'
    mail(to: @user.email, subject: "Welcome to blogapp.com Site")
  end


end
