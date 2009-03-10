class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.date :date_of_birth
      t.integer :serial_number, :null => false
      t.timestamps
    end
    add_index :people, [:lastname, :firstname, :serial_number], :unique => true
  end

  def self.down
    drop_table :people
  end
end
