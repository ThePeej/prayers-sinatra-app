class CreateGroups < ActiveRecord::Migration[5.1]
  def change
  	create_table :groups do |t|
  		t.string :name
  		t.text :description
  		t.boolean :private, :default => true
  	end
  end
end
