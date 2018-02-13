class Group < ActiveRecord::Base
	validates :name, presence: true
	validates :leader, presence: true

	has_many :prayers, through: :users

	has_many :user_groups
	has_many :members, through: :user_groups, :source => :group_member

	belongs_to :leader, :class_name => "User"
end