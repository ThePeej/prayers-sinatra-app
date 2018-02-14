class User < ActiveRecord::Base
	validates :username, presence: true
  	validates :email, presence: true
  	has_secure_password
  	
	has_many :prayers, :foreign_key => "author_id"

	has_many :user_groups
	has_many :groups, through: :user_groups

	has_many :lead_groups, :foreign_key => "leader_id", :class_name => "Group"
end