class User < ActiveRecord::Base
	validates :username, presence: true
  	validates :email, presence: true
  	has_secure_password
  	
	has_many :prayers
	has_many :user_groups
	has_many :groups, through: :user_groups
end