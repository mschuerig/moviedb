class CreateAwardings < ActiveRecord::Migration
  def self.up
    create_table :awardings do |t|
      t.belongs_to :award, :null => false
      t.integer :year, :null => false
      t.timestamps
    end
      
    add_index :awardings, [:award_id, :year], :unique => true
  end

  def self.down
    drop_table :awardings
  end
end
