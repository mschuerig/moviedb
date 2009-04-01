
module DbUtils
  class IndexLifter
    SYSTEM_TABLES = ['schema_migrations'].freeze
    
    def self.without_indexes(*tables, &block)
      IndexLifter.new(*tables).without_indexes(&block)
    end
    
    def initialize(*tables)
      @connection = ActiveRecord::Base.connection
      @tables = (tables.empty? ? @connection.tables : tables) - SYSTEM_TABLES
    end
      
    def without_indexes(&block)
      indexes = index_definitions
      lift_indexes(indexes)
      yield
    ensure
      reinstate_indexes(indexes)
    end
    
    private
    
    def lift_indexes(indexes)
      indexes.each do |idx|
        @connection.remove_index(idx.table, :name => idx.name)
      end
    end
    
    def reinstate_indexes(indexes)
      indexes.each do |idx|
        @connection.add_index(idx.table, idx.columns, :unique => idx.unique)
      end
    end
    
    def index_definitions
      @tables.inject([]) do |defs, table|
        defs += @connection.indexes(table)
      end
    end
  end
end
