
class ActiveRecord::Base
  def self.foreign_keys
    reflect_on_all_associations.select { |r| r.macro == :belongs_to }.map do |r|
      r.options[:foreign_key] || r.name.to_s.foreign_key
    end
  end
  def self.mandatory_foreign_keys
    foreign_keys.select { |fk| mandatory_column?(fk) }
  end
  def self.optional_foreign_keys
    foreign_keys.reject { |fk| mandatory_column?(fk) }
  end
  def self.mandatory_column?(name)
    !columns_hash[name.to_s].null
  end
end

module MigrationHelpers
  
  def foreign_key(from_table, *from_columns)
    to_table = nil
    if from_columns.size == 2 && from_columns.to_s !~ /_id$/
      to_table = from_columns.pop
    end
    from_columns.each do |from_col|
      to = if to_table
        to_table
      else
        from_col.to_s =~ /^(.+)_id$/
        to = $1.pluralize
      end
      add_foreign_key_constraint(from_table, from_col, to)
    end
  end
  
  def add_not_null(table, *columns)
    transmogrify_column_types(table, *columns) { |column| "#{column.sql_type} NOT NULL" }
  end
  
  def remove_not_null(table, *columns)
    transmogrify_column_types(table, *columns) { |column| "#{column.sql_type}" }
  end
  
  def add_not_nulls_to_join_table(table, col1, col2)
    change_column_type(table, col1, "int(11) NOT NULL")
    change_column_type(table, col2, "int(11) NOT NULL")
  end

  def remove_default(table, *columns)
    transmogrify_column_types(table, *columns) do |column|
      if column.null
        "#{column.sql_type} NOT NULL"
      else
        "#{column.sql_type}"
      end
    end
  end

  def remove_foreign_key(table, column)
    execute %{ALTER TABLE #{table} DROP FOREIGN KEY fk_#{table}_#{column}}
  end
  
  def drop_column_default(table, *columns)
    columns.each do |column|
      execute %{ALTER TABLE #{table} ALTER COLUMN #{column} DROP DEFAULT}
    end
  end
  
  def find_records_with_zero_foreign_keys(table)
    klass = table.kind_of?(Class) && table < ActiveRecord::Base ? table : table.to_s.singularize.classify.constantize
    if !klass.mandatory_foreign_keys.empty?
      klass.find(:all, :conditions => klass.mandatory_foreign_keys.map { |fk| "#{fk} = 0" }.join(' OR '))
    else
      []
    end
  end
  
  def model_classes
    models = []
    Find.find('app/models') do |f|
      next if f =~ /\.svn$/
      next unless f =~ /\.rb$/
      class_decl = File.readlines(f).grep(/class\s+.*\s+<\s+ActiveRecord::Base/).first
      if not (class_decl.blank? or class_decl.empty?)
        class_decl =~ /class\s+(.+)\s+<\s+ActiveRecord::Base/
        models << $1.constantize
      end
    end
    models
  end
  
  def find_bad_foreign_keys
    model_classes.map { |m| [m, find_records_with_zero_foreign_keys(m)] }.select { |(m, bad)| !bad.empty? }
  end
  
  
  private

  def add_foreign_key_constraint(from_table, from_column, to_table)
    constraint_name = "fk_#{from_table}_#{from_column}"
    execute %{
ALTER TABLE #{from_table}
  ADD CONSTRAINT #{constraint_name}
  FOREIGN KEY (#{from_column})
  REFERENCES #{to_table}(id)}
  end
  
  def transmogrify_column_types(table, *columns)
    klass = table.to_s.singularize.classify.constantize
    raise "No such table: #{table}" unless klass
    raise "A block for changing the column type is required" unless block_given?

    columns.map(&:to_s).each do |column_name|
      column = klass.columns_hash[column_name]
      raise "No such column: #{table}.#{column_name}" unless column
      new_type = yield column
      change_column_type(table, column_name, new_type)
    end
  end

  def change_column_type(table, col_name, col_type)
    col_name = quote_column_name(col_name)  
    execute %{ALTER TABLE #{table} CHANGE COLUMN #{col_name} #{col_name} #{col_type}}
  end

end
