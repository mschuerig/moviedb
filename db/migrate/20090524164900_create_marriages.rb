
require 'migration_helpers'

class CreateMarriages < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :marriages_internal do |t|
      t.belongs_to :person1, :null => false
      t.belongs_to :person2, :null => false
      t.date       :start_date, :null => false
      t.date       :end_date
      t.integer    :lock_version, :default => 0, :null => false
    end
    foreign_key :marriages_internal, :person1_id, :people
    foreign_key :marriages_internal, :person2_id, :people
    add_index :marriages_internal, [:person1_id, :person2_id]
    add_index :marriages_internal, :person2_id
    
    create_view :marriages,
        %{SELECT id, person1_id, person2_id, start_date, end_date, lock_version FROM marriages_internal
          UNION
          SELECT id, person2_id, person1_id, start_date, end_date, lock_version FROM marriages_internal
        } do |v|
      v.column :id
      v.column :person_id
      v.column :spouse_id
      v.column :start_date
      v.column :end_date
      v.column :lock_version
    end

    execute <<-SQL
CREATE RULE marriages_insert AS ON INSERT TO marriages DO INSTEAD
INSERT INTO marriages_internal (person1_id, person2_id, start_date, end_date, lock_version)
VALUES (LEAST(NEW.person_id, NEW.spouse_id), 
        GREATEST(NEW.person_id, NEW.spouse_id),
        NEW.start_date,
        NEW.end_date,
        NEW.lock_version
       )
RETURNING id, person1_id, person2_id, start_date, end_date, lock_version;

CREATE RULE marriages_update AS ON UPDATE TO marriages DO INSTEAD
UPDATE marriages_internal
SET start_date   = NEW.start_date,
    end_date     = NEW.end_date,
    lock_version = NEW.lock_version
WHERE (id = OLD.id) AND (lock_version = OLD.lock_version);

CREATE RULE marriages_delete AS ON DELETE TO marriages DO INSTEAD
DELETE FROM marriages_internal
WHERE (id = OLD.id) AND (lock_version = OLD.lock_version);
    SQL
  end

  def self.down
    execute <<-SQL
DROP RULE marriages_insert ON marriages;
DROP RULE marriages_update ON marriages;
DROP RULE marriages_delete ON marriages;
    SQL

    drop_view  :marriages
    drop_table :marriages_internal
  end
end
