class User < ActiveRecord::Base
  has_secure_password
  #apply_simple_captcha
  #attr_accessor :captcha, :captcha_key
  before_save do
    self.email_confirmation_id = generate_random
  end
  
  attr_accessor :terms, :email_confirmed #, :password, :password_confirmation

  validates :password, length: {within: 6..16  } 

  validates_presence_of :terms, :message => "must be present", :on => 'create'
  validates_numericality_of :terms, :equal_to => 1, :message => "must be accepted", :on => 'create'

  validates_presence_of :username, :message => "field can't be blank"
  validates_uniqueness_of :username, :message => "has already been taken"
  validates_format_of :username, :with => /\A[_a-zA-Z]([\.\-_a-zA-Z0-9]+)[_\-a-zA-Z0-9]\z/, :message => "must contain valid characters"
  validates_length_of :username, :within =>3..16 ,:message => "must be between 3 and 16 characters"
  
  
  validates_presence_of :email, :message => "field can't be blank"
  validates_presence_of :email_confirmation, :message => "must have the same email", :on => :create
  validates_confirmation_of :email, :message => "should match confirmation"
  validates_uniqueness_of :email, :message => "has already been used"
  validates_length_of :email, :maximum => 28, :message => "must be maximum 28 characters long"
  validates_format_of :email, :with => /\A[_a-zA-Z0-9]([\-+_%.a-zA-Z0-9]+)?@([_+\-%a-zA-Z0-9]+)(\.[a-zA-Z0-9]{0,6}){1,2}([a-zA-Z0-9]\z)/, :message => "must be in a valid format"

  validates_presence_of :first_name, :message => "field can't be blank"
  validates_length_of :first_name, :within => 2..16 ,:message => " must be between 2 and 16 characters"
  validates_format_of :first_name, :with => /\A[_a-zA-Z]([a-zA-Z]+)?[a-zA-Z]\z/, :message => "must be in a valid format"

  validates_length_of :mid_name, :within => 0..16 ,:message => " must be between 2 and 16 characters"
  validates_format_of :mid_name, :with => /(\A[_a-zA-Z]([a-zA-Z]+)?[a-zA-Z]\z)|(\A\Z)/, :message => "must be in a valid format"

  validates_presence_of :last_name, :message => "field can't be blank"
  validates_length_of :last_name, :within => 2..16 ,:message => " must be between 2 and 16 characters"
  validates_format_of :last_name, :with => /\A[_a-zA-Z]([a-zA-Z]+)?[a-zA-Z]\z/, :message => "must be in a valid format"

  
  validates_presence_of :birth, :message => "field can't be blank"
  validate :is_date?, :message => "not valid"
  validate :valid_year?, :message => "doesn't have a valid birth year"
  

  private

  def is_date?
    temp = birth.to_s.gsub(/[-.\/]/, '')
    ['%Y%m%d','%y%m%d','%Y%M%D','%y%M%D'].each do |f|
    begin
      return true if Date.strptime(temp, f)
        rescue
         #do nothing
      end
    end
    errors.add(:birth, "not valid")
  end

  def valid_year?
    b = Date.parse(birth.to_s)
    if (b.year < 1900 || b.year > 2010)
      errors.add(:birth, "year not valid")
    end
  end


  def generate_random
    r=""
    20.times {r += (65+rand(26)).chr}
    r
  end

end


