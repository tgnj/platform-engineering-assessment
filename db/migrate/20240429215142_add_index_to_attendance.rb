class AddIndexToAttendance < ActiveRecord::Migration[7.1]
  def change
    add_index :attendances, :entity_identifier
    add_index :attendances, :site_identifier

    add_index :attendances, :sign_in_time
    add_index :attendances, :sign_out_time
  end
end
