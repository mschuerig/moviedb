class AddLockVersions < ActiveRecord::Migration
  def self.up
    add_column :awards, :lock_version, :integer, :null => false, :default => 0
    add_column :movies, :lock_version, :integer, :null => false, :default => 0
    add_column :people, :lock_version, :integer, :null => false, :default => 0
    add_column :roles,  :lock_version, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :awards, :lock_version
    remove_column :movies, :lock_version
    remove_column :people, :lock_version
    remove_column :roles,  :lock_version
  end
end
