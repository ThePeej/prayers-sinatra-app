class AddTimestampsToPrayers < ActiveRecord::Migration[5.1]
  def change
  	add_timestamps :prayers, null: true
  end
end
