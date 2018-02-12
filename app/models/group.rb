class Group < ActiveRecord::Base
	validates :name, presence: true

	has_many :user_groups
	has_many :users, through: :user_groups

	has_many :prayers, through: :users
end