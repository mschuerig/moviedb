class AwardNestedSet < ActiveRecord::Migration
  def self.up
    change_table :awards do |t|
      t.integer :lft
      t.integer :rgt
    end
    Award.rebuild!
  end

  def self.down
    change_table :awards do |t|
      t.remove :lft
      t.remove :rgt
    end
  end
end
