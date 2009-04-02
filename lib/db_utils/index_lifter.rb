
module DbUtils
  class IndexLifter
    SYSTEM_TABLES = ['schema_migrations'].freeze
    
    def self.without_indexes(*tables, &block)
      IndexLifter.new(*tables).without_indexes(&block)
    end
    
    def initialize(*tables)
      @options = tables.extract_options!
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
      indexes = @tables.inject([]) { |defs, table|
        defs += @connection.indexes(table)
      }
      if @options[:except_unique]
        indexes.delete_if(&:unique)
      end
      exceptions = [@options[:except]].flatten
      exception_names = exceptions.map { |exc| (exc.kind_of?(::Hash) ? exc[:name] : exc).to_s }
      indexes.delete_if { |idx| exception_names.include?(idx.name) }
      exception_hashes = exceptions.select { |exc| exc.kind_of?(::Hash) }.map { |exc|
        { :table => exc[:table].to_s,
          :columns => Array(exc[:column] || exc[:columns]).map(&:to_s)
        }}
      indexes.delete_if { |idx| exception_hashes.any? { |exc|
          exc[:table]   == idx.table && 
          exc[:columns] == idx.columns
        }}
      indexes
    end
  end
end
