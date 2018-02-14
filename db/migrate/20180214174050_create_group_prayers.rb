class CreateGroupPrayers < ActiveRecord::Migration[5.1]
  def change
  	create_table :group_prayers do |t|
  		t.integer :group_id
  		t.integer :prayer_id
  	end
  end
end
