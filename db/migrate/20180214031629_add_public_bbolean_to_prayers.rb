class AddPublicBboleanToPrayers < ActiveRecord::Migration[5.1]
  def change
  	remove_column :prayers, :anonymous, :boolean
  	add_column :prayers, :anonymous, :boolean
  	add_column :prayers, :public?, :boolean
  end
end
