
require 'ruby-debug' ### REMOVE

namespace :db do
  
  task :branches => "branches:list"

  namespace :branches do
    
    desc "List all branch databases"
    task :list => "db:load_config" do
      puts BranchSwitcher.which.branches
    end
    
    desc "Initialize per branch databases."
    task :init => "db:load_config" do
      each_local_database { |switcher| switcher.create_initial }
    end
    
    desc "Currently selected databases."
    task :current => "db:load_config" do
      each_local_database { |switcher| switcher.current }
    end
    
    desc "Switch to the databases for the currently checked out git branch."
    task :switch => "db:load_config" do
      each_local_database { |switcher| switcher.select }
    end

    desc "Copy databases for a new branch. Default is 'master', set ORIG_BRANCH=some_branch"
    task :copy => "db:load_config" do
      if target_branch == current_branch
        $stderr.puts "Cannot copy database to itself."
      else
        each_local_database { |switcher| switcher.copy_from(originating_branch) }
      end
    end

    desc "Delete databases for a branch."
    task :delete => "db:load_config" do
      if target_branch == current_branch
        $stderr.puts "Cannot delete databases for the current branch."
      else
        each_local_database { |switcher| switcher.delete }
      end
    end
    
    def current_branch
      #@current_branch ||= `git symbolic-ref HEAD`.sub(%r{^refs/heads/}, '').chomp
      @current_branch ||= `git rev-parse --symbolic-full-name HEAD`.sub(%r{^refs/heads/}, '').chomp
    end
    
    def environment_options
      { 
        :overwrite => ENV['OVERWRITE']
      }
    end
    
    def target_branch
      ENV['BRANCH'] || current_branch
    end

    def originating_branch
      ENV['ORIG_BRANCH'] || 'master' ### TODO determine originating branch
    end
    
    def each_local_config
      ActiveRecord::Base.configurations.each_value do |config|
        next unless config['database']
        next unless config['per_branch']
        local_database?(config) do
          yield config
        end
      end
    end
    
    def each_local_database(*args)
      options = args.last.kind_of?(Hash) ? args.pop : {}
      options = options.reverse_merge(environment_options)
      branch = args[0] || target_branch
      each_local_config do |config|
        yield BranchSwitcher.create(config, branch, options, RAILS_ENV)
      end
    end

    class BranchSwitcher
      def self.which
        config = ActiveRecord::Base.configurations[RAILS_ENV]
        case config['adapter']
        when /sqlite/
          SqliteSwitcher
        when 'postgresql'
          PostgresqlSwitcher
        else
          $stderr.puts 'Your database adapter is not supported yet.'
          BranchSwitcher
        end
      end
      
      def self.create(config, branch, rails_env, options = {})
        which.new(config, branch, options, rails_env)
      end
      
      def initialize(config, branch, rails_env, options)
        @config, @branch, @rails_env = config, branch, rails_env
        @overwrite = options[:overwrite]
      end

      def self.branches
      end

      def current
      end
      
      def create_initial
      end
      
      def copy_from(other_branch)
      end
      
      def select
      end
      
      def delete
      end
    end
    
    class SqliteSwitcher < BranchSwitcher
      DB_ROOT = File.join(RAILS_ROOT, 'db')
      BRANCH_ROOT = File.join(DB_ROOT, 'branches')
      
      def initialize(config, branch, options, rails_env)
        super
        @db, @branch_db = db_path, branch_db_path
      end
      
      def self.branches
        Dir[File.join(BRANCH_ROOT, '*')].map { |b| File.basename(b) }
      end
      
      def current
        status = relative_path(@db)
        if File.symlink?(@db)
          status << " -> SQLite3 #{File.readlink(@db)}"
        end
        status << " (doest not exist)" unless File.exist?(@db)
        puts status
      end
      
      def create_initial
        make_branch_dir
        unless File.exist?(@branch_db)
          FileUtils.mv(@db, @branch_db) if File.exist?(@db)
          FileUtils.ln_s(relative_path(@branch_db), @db)
        end
      end

      def copy_from(other_branch)
        other_db = branch_db_path(other_branch)
        if !@overwrite && File.exist?(@branch_db) && !File.symlink?(@branch_db)
          $stderr.puts "A database file #{@branch_db} exists already."
        elsif File.exist?(other_db)
          make_branch_dir
          ### TODO make sure that symlinks are copied as symlinks
          FileUtils.cp(other_db, @branch_db)
        end
      end

      def select
        ensure_branch_exists!
        FileUtils.ln_sf(relative_path(branch_db_path), db_path)
      end
      
      def delete
        FileUtils.rm_f(branch_db_path)
        FileUtils.rmdir(branch_dir) rescue nil
      end

      private
      
      def db_path
        File.join(RAILS_ROOT, @config['database'])
      end
      
      def branch_dir(branch = @branch)
        File.join(BRANCH_ROOT, branch)
      end
      
      def branch_db_path(branch = @branch)
        File.join(branch_dir(branch), File.basename(db_path))
      end

      def make_branch_dir(branch = @branch)
        FileUtils.mkdir_p(branch_dir(branch))
      end
      
      def branch_exists?(branch = @branch)
        File.directory?(branch_dir(branch))
      end
      
      def ensure_branch_exists!(branch = @branch)
        unless branch_exists?(branch)
          raise "There is no database for the branch #{@branch}."
        end
      end

      def relative_path(s)
        s.sub(%r{^#{DB_ROOT}/}, '')
      end
    end

    class PostgresqlSwitcher < BranchSwitcher
      def self.branches
        ### TODO
        puts "++++ PostgreSQL branches"
      end

      def current
        puts "#{@branch} -> PostgreSQL #{@config['database']}"
      end
      
      def copy_from(other_branch)
        ### TODO
        puts @rails_env
        puts branch_db_config(other_branch).inspect
#        create_branch_db
#        dump_branch_db(other_branch)
      end
      
      def select
        ### TODO
      end
      
      def delete
        ### TODO
      end
      
      private
      
      def copy_branch_db(from_branch)
        require 'tempfile'
        
        ### FIXME determine config for from_branch
        from_config = @config
        
        old_umask = File.umask(0077) # make created files readable only to the user
        dump_file = Tempfile.new('branchdb')
        sh %{pg_dump --clean -U "#{from_config['username']}" --host="#{from_config['host']}" --port=#{from_config['port']} #{from_config['database']} > #{dump_file.path}}
      ensure
        File.umask(old_umask)
      end
      
      def branch_db_config(from_branch)
        database = @config['database']
        branch_database = database.sub(/(_.+?)??(_?(#{@rails_env}))?$/, "_#{@branch}\\2")
        @config.dup.merge('database' => branch_database)
      end
      
      def write_branch_db_config
        ### TODO
      end
      
      def create_branch_db
        ### FIXME
        ActiveRecord::Base.establish_connection(@config)
        ActiveRecord::Base.connection
      end
      
    end
  end
end
