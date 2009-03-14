class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.string :name, :null => false
      t.belongs_to :award_group, :null => false
      t.timestamps
    end

    add_index :awards, [:name, :award_group_id], :unique => true
  end

  def self.down
    drop_table :awards
  end
end
