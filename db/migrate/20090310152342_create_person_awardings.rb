class CreatePersonAwardings < ActiveRecord::Migration
  def self.up
    create_table :person_awardings do |t|
      t.integer :year, :null => false
      t.belongs_to :person_award, :null => false
      t.belongs_to :person, :null => false
      t.belongs_to :movie, :null => false
      t.timestamps
    end
    add_index :person_awardings, [:person_id, :movie_id, :year, :person_award_id], :unique => true
    add_index :person_awardings, :movie_id
    add_index :person_awardings, :person_award_id
  end

  def self.down
    drop_table :person_awardings
  end
end
