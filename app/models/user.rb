class User < ActiveRecord::Base

	#before_save { self.email = email.downcase}

	#exercise 2
	before_save {email.downcase!}

	validates :name, presence: true, length: {maximum: 50}
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	validates(:email, presence: true, format: {with: EMAIL_REGEX},
					  uniqueness: {case_sensitive: false})
	has_secure_password
	validates(:password, length: {minimum: 6})
	#validates(:password, presence: true, length: {minimum: 6})
	#validates(:password_confirmation, presence: true)
end
