     class RenamePrayersDescriptionToDetails < ActiveRecord::Migration[5.1]
       def change
       		rename_column :prayers, :description, :details
       end
     end
