
require 'migration_helpers'

class CreateMarriages < ActiveRecord::Migration
  extend MigrationHelpers
  
  def self.up
    create_table :marriages do |t|
      t.belongs_to :person, :null => false
      t.belongs_to :spouse, :null => false
      t.date       :start_date, :null => false
      t.date       :end_date
      t.integer    :lock_version, :default => 0, :null => false
    end
    foreign_key :marriages, :person_id
    foreign_key :marriages, :spouse_id, :people
    add_index :marriages, [:person_id, :spouse_id]
    add_index :marriages, :spouse_id
  end

  def self.down
    drop_table :marriages
  end
end
