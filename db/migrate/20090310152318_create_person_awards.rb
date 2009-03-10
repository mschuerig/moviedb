class CreatePersonAwards < ActiveRecord::Migration
  def self.up
    create_table :person_awards do |t|
      t.string :name, :null => false
      t.belongs_to :award_group, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :person_awards
  end
end
