
namespace :db do
  namespace :branches do
    
    desc "Initialize per branch databases."
    task :init => "db:load_config" do
      each_local_database { |switcher| switcher.create_initial }
    end
    
    desc "Switch to the DB for the currently checked out git branch."
    task :switch => "db:load_config" do
      each_local_database { |switcher| switcher.select }
    end

    desc "Copy databases for a new branch."
    task :copy => "db:load_config" do
      from_branch = ENV['FROM_BRANCH'] || 'master' ### FIXME determine originating branch
      each_local_database { |switcher| switcher.copy_from(from_branch) }
    end

    def current_branch
      ENV['BRANCH'] || `git symbolic-ref HEAD`.sub(%r{^refs/heads/}, '').chomp
    end
    
    def each_local_database
      ActiveRecord::Base.configurations.each_value do |config|
        next unless config['database']
        local_database?(config) do
          yield BranchSwitcher.create(config, current_branch)
        end
      end
    end

    class BranchSwitcher
      def self.create(config, branch)
        case config['adapter']
        when /sqlite/
          SqliteSwitcher.new(config, branch)
        else
          puts 'sorry, your database adapter is not supported yet, feel free to submit a patch'
          BranchSwitcher.new(config, branch)
        end
      end
      
      def initialize(config, branch)
        @config, @branch = config, branch
      end
      
      def create_initial
      end
      
      def copy_from(other_branch)
      end
      
      def select
      end
    end
    
    class SqliteSwitcher < BranchSwitcher
      def initialize(config, branch)
        super
        @db, @branch_db = db_path, branch_db_path
      end
      
      def create_initial
        make_branch_db_dir
        unless File.exist?(@branch_db)
          FileUtils.mv(@db, @branch_db) if File.exist?(@db)
          FileUtils.ln_s(@branch_db, @db)
        end
      end

      def copy_from(other_branch)
        other_db = branch_db_path(other_branch)
        if File.exist?(@branch_db)
          $stderr.puts "A database file #{@branch_db} exists already."
        elsif File.exist?(other_db)
          make_branch_db_dir
          FileUtils.cp(other_db, @branch_db)
        end
      end

      def select
        ensure_branch_exists!
        FileUtils.ln_sf(branch_db_path, db_path)
      end

      private
      
      def db_path
        File.join(RAILS_ROOT, @config['database'])
      end
      
      def branch_dir(branch = @branch)
        File.join(RAILS_ROOT, 'db', 'branches', branch)
      end
      
      def branch_db_path(branch = @branch)
        File.join(branch_dir(branch), File.basename(db_path))
      end

      def make_branch_db_dir
        FileUtils.mkdir_p(File.dirname(@branch_db))
      end
      
      def ensure_branch_exists!
        unless File.directory?(branch_dir)
          raise "There is no database for the branch #{@branch}."
        end
      end
    end
  end
end
