class UserGroup < ActiveRecord::Base
	belongs_to :group_member, :class_name=> "User", :foreign_key => "user_id"
	belongs_to :group
end