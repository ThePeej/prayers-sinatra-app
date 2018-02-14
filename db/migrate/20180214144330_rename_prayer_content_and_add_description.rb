class RenamePrayerContentAndAddDescription < ActiveRecord::Migration[5.1]
  def change
  	add_column :prayers, :overview, :string
  	rename_column :prayers, :content, :description
  end
end
