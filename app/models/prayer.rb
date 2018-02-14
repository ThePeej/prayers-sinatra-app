class Prayer < ActiveRecord::Base
	validates :overview, presence: true
	
	belongs_to :author, :class_name => "User"

	has_many :group_prayers
	has_many :groups, through: :group_prayers

end