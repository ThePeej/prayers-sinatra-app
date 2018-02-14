class AddColumnAnonymousBoolean < ActiveRecord::Migration[5.1]
  def change
  	add_column :prayers, :anonymous, :boolean
  end
end
