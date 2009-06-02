class AddPersonDuplicateCount < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.integer :duplicate_count
    end
    execute %{UPDATE people AS p1 SET duplicate_count = (SELECT COUNT(*) FROM people AS p2 WHERE (p1.firstname, p1.lastname) = (p2.firstname, p2.lastname))}
    change_column :people, :duplicate_count, :integer, :null => false
  end

  def self.down
    remove_column :people, :duplicate_count
  end
end
