class AddChurchAndVerseToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :church, :string
  	add_column :users, :verse, :text
  end
end
