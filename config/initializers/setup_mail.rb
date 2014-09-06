puts "********************** Loading SMTP Settings ******************"
ActionMailer::Base.smtp_settings = {
  address:        'smtp.gmail.com', # default: localhost
  port:           '587',                  # default: 25
  user_name:      'jimnolleen@gmail.com',
  password:       'pp1234ss',
  authentication: :plain                 # :plain, :login or :cram_md5
}