class Prayer < ActiveRecord::Base
	validates :overview, presence: true
	
	belongs_to :author, :class_name => "User"

end