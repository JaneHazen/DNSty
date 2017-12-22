class AddZoneIdToRecords < ActiveRecord::Migration[5.1]
  def change
    add_reference :records, :zone, foreign_key: true
  end
end
