class Group < ActiveRecord::Base
	validates :name, presence: true
	validates :leader, presence: true

	has_many :user_groups
	has_many :members, through: :user_groups, :source => :group_member

	has_many :prayers, through: :members

	belongs_to :leader, :class_name => "User"
end