
require 'ruby-debug' ### REMOVE

namespace :db do
  
  task :branches => "branches:list"

  namespace :branches do
    
    desc "List all branch databases"
    task :list => "db:load_config" do
      puts BranchSwitcher.which.branches
    end
    
    desc "Currently selected databases."
    task :current => "db:load_config" do
      each_local_database { |switcher| switcher.current }
    end

    #desc "Create an empty database for a branch"
    task :create => "db:load_config" do
      ### TODO
      ### TODO restart passenger etc.
    end
    
    desc "Copy databases from one branch to another. Default is from ORIG_BRANCH=master to BRANCH=<current branch>"
    task :copy => "db:load_config" do
      if originating_branch == current_branch
        $stderr.puts "Cannot copy database to itself."
      else
        each_local_database { |switcher| switcher.copy_from(originating_branch) }
        ### TODO restart passenger etc.
      end
    end

    desc "Delete databases for a branch. Current branch or BRANCH"
    task :delete => "db:load_config" do
      if target_branch == current_branch
        $stderr.puts "Cannot delete databases for the current branch."
      else
        each_local_database { |switcher| switcher.delete }
        ### TODO restart passenger etc.
      end
    end
    
    #desc "Show sizes of all branch databases"
    task :size do
      ### TODO
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
      
      def copy_from(from_branch)
      end
      
      def delete
      end
    end

=begin
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
      
      ### REMOVE
      def create_initial
        make_branch_dir
        unless File.exist?(@branch_db)
          FileUtils.mv(@db, @branch_db) if File.exist?(@db)
          FileUtils.ln_s(relative_path(@branch_db), @db)
        end
      end
      
      def copy_from(from_branch)
        from_db = branch_db_path(from_branch)
        ensure_branch_db_exists!(from_db)
        if !@overwrite && File.exist?(@branch_db) && !File.symlink?(@branch_db)
          $stderr.puts "A database file #{@branch_db} exists already."
        elsif File.exist?(from_db)
          make_branch_dir
          ### TODO make sure that symlinks are copied as symlinks
          FileUtils.cp(from_db, @branch_db)
        end
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
      
      def ensure_db_branch_exists!(branch)
        unless branch_exists?(branch)
          raise "There is no database for the branch #{branch}."
        end
      end

      def relative_path(s)
        s.sub(%r{^#{DB_ROOT}/}, '')
      end
    end
=end
    
    class PostgresqlSwitcher < BranchSwitcher
      def self.branches
        ### TODO determine from per_branch, if it is a Hash
        puts "++++ PostgreSQL branches"
      end

      def current
        branch = branch_db_exists?(@branch) ? @branch : 'master'
        puts "#{@rails_env}: #{branch_db(branch)} (PostgreSQL)"
      end
      
      def copy_from(from_branch)
        ### REMOVE
        puts "ENV: #{@rails_env}"
        puts "BRANCH: #{@branch}"
        puts "FROM CONFIG: #{branch_config(from_branch).inspect}"
        puts "TO CONFIG: #{branch_config(@branch).inspect}"
        
        ### TODO extract to template method
        ensure_branch_db_exists!(from_branch)
        if branch_db_exists?(@branch)
          if !@overwrite
            $stderr.puts "A database #{branch_db(@branch)} exists already."
            return
          else
            puts "Dropping existing database #{branch_db(@branch)}..."
            drop_database(branch_config(@branch))
          end
        end
        puts "Creating fresh database #{branch_db(@branch)}..."
        create_database(branch_config(@branch))
        puts "Copying data..."
        copy_branch_db(from_branch, @branch)
      end
      
      def delete
        ensure_branch_db_exists!(@branch)
        drop_database(@config)
      end
      
      private
      
      def existing_databases
        @existing_databases ||=
          begin
            raw_dbs = `psql -l`
            if $? == 0
              existing_dbs = raw_dbs.split("\n").drop_while { |l| l !~ /^-/ }.drop(1).take_while { |l| l !~ /^\(/ }.map { |l| l.split('|')[0].strip }
              existing_dbs.reject { |db| db =~ /^template/ }
            else
              raise "Cannot determine existing databases."
            end
          end
      end
      
      def db_exists?(db)
        existing_databases.include?(db)
      end
      
      def branch_db_exists?(branch)
        db_exists?(branch_db(branch))
      end
      
      def ensure_branch_db_exists!(branch)
        unless branch_db_exists?(branch)
          raise "There is no database for the branch #{branch}."
        end
      end
      
      def copy_branch_db(from_branch, to_branch)
        dump_file = dump_branch_db(from_branch)
        load_branch_db(to_branch, dump_file)
      end
      
      def dump_branch_db(branch)
        require 'tempfile'
        config = branch_config(branch)
        old_umask = File.umask(0077) # make created files readable only to the user
        dump_file = Tempfile.new('branchdb')
        sh %{pg_dump --clean -U "#{config['username']}" --host="#{config['host']}" --port=#{config['port']} #{config['database']} > #{dump_file.path}}
        dump_file.path
      ensure
        File.umask(old_umask)
      end
      
      def load_branch_db(branch, dump_file)
        config = branch_config(branch)
        sh %{psql -U "#{config['username']}" -f "#{dump_file}" --host="#{config['host']}" --port=#{config['port']} #{config['database']}}
      end
      
      def branch_config(branch)
        @config.merge('database' => branch_db(branch))
      end

      def branch_db(branch)
        if branch == 'master'
          @config['database']
        else
          @config['database'].sub(/(_.+?)??(_?(#{@rails_env}))?$/, "_#{branch}\\2")
        end
      end

    end
  end
end
