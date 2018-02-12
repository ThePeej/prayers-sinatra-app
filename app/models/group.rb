class Group < ActiveRecord::Base
	validates :content, presence: true
	
	has_many :user_groups
	has_many :users, through: :user_groups
end