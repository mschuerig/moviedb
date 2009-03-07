class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.date :date_of_birth

      t.timestamps
    end
    add_index :people, [:lastname, :firstname, :date_of_birth], :unique => true
  end

  def self.down
    drop_table :people
  end
end
