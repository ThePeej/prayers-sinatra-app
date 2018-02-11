class CreatePrayers < ActiveRecord::Migration[5.1]
  def change
  	create_table :prayers do |t|
  		t.text :content
  		t.integer :user_id
  	end
  end
end
