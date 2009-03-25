class AddTitleToRoleType < ActiveRecord::Migration
  def self.up
    add_column :role_types, :title, :string
    execute "UPDATE role_types SET title = name, name = LOWER(name)"
    change_column :role_types, :title, :string, :null => false
  end

  def self.down
    remove_column :role_types, :title
  end
end
