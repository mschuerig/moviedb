class AwardRequirementsAssocRoleTypeCount < ActiveRecord::Migration
  def self.up
    change_table(:award_requirements) do |t|
      t.column :association, :string
      t.belongs_to :role_type
      t.column :count, :integer
    end

    execute "UPDATE award_requirements SET count = 1"
    execute "UPDATE award_requirements SET" +
      " association = 'people'," + 
      " role_type_id = (SELECT id FROM role_types WHERE name = 'actor')" +
      "WHERE required_type = 'Person'"
    execute "UPDATE award_requirements SET association = 'movies' WHERE required_type = 'Movie'"
    
    remove_column :award_requirements, :required_type
    
    change_column :award_requirements, :association, :string, :null => false
    change_column :award_requirements, :count, :integer, :null => false
  end

  def self.down
    add_column :award_requirements, :required_type, :string
    
    execute "UPDATE award_requirements SET required_type = 'Person' WHERE association = 'people'"
    execute "UPDATE award_requirements SET required_type = 'Movie' WHERE association = 'movies'"
    
    change_column :award_requirements, :required_type, :string, :null => false
    remove_columns :award_requirements, :association, :role_type_id, :count
  end
end
