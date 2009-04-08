
module BranchDB # :nodoc:

  class Switcher
    def self.which(rails_env = RAILS_ENV)
      config = ActiveRecord::Base.configurations[rails_env]
      switcher = Array(@switchers).detect { |sw| sw.can_handle?(config) }
      unless switcher
        $stderr.puts 'Your database adapter is not supported yet.'
        switcher = self # double as null switcher
      end
      switcher
    end
    
    def self.can_handle?(config)
      raise "Subclasses of BranchDB::Switcher must implement #can_handle?(config)."
    end
    
    def self.create(config, branch, rails_env, options = {})
      which(rails_env).new(config, branch, rails_env, options)
    end
    
    def initialize(config, branch, rails_env, options)
      @config, @branch, @rails_env = config, branch, rails_env
      @overwrite = options[:overwrite]
    end

    def self.branches
    end

    def current
    end
    
    def create_empty_database
      db = branch_db(@branch)
      if branch_db_exists?(@branch)
        if !@overwrite
          $stderr.puts "Database #{db} exists already."
          return
        else
          puts "Dropping existing database #{db}..."
          drop_database(@branch)
        end
      end
      puts "Creating fresh database #{db}..."
      create_database(@branch)
      yield
    end
    
    def delete_database
      ensure_branch_db_exists!(@branch)
      puts "Dropping existing database #{branch_db(@branch)}..."
      drop_database(@branch)
    end
    
    def copy_from(from_branch)
      ensure_branch_db_exists!(from_branch)

      create_empty_database do
        puts "Copying data..."
        copy_database(from_branch, @branch)
      end
    end
    
    protected
    
    def branch_config(branch)
      @config.merge('database' => branch_db(branch))
    end

    def ensure_branch_db_exists!(branch)
      unless branch_db_exists?(branch)
        raise "There is no database for the branch #{branch}."
      end
    end

    def branch_db(branch)
    end
    
    def branch_db_exists?(branch)
    end
    
    def create_database(branch)
    end
    
    def drop_database(branch)
    end
    
    def copy_database(from_branch, to_branch)
    end
    
    private
    
    def self.inherited(child)
      @switchers ||= []
      @switchers << child
    end
  end
end
