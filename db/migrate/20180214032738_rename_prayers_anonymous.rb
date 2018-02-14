class RenamePrayersAnonymous < ActiveRecord::Migration[5.1]
  def change
  	rename_column :prayers, :anonymous, :anonymous?
  	rename_column :prayers, :user_id, :author_id
  end
end
