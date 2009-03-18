
namespace :db do
  namespace :branches do
    
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
      each_local_database { |switcher| switcher.copy_from(originating_branch) }
    end

    desc "Link to databases of another branch. Default is 'master', set ORIG_BRANCH=some_branch"
    task :copy => "db:load_config" do
      each_local_database { |switcher| switcher.link_to(originating_branch) }
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
      `git symbolic-ref HEAD`.sub(%r{^refs/heads/}, '').chomp
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
        local_database?(config) do
          yield config
        end
      end
    end
    
    def each_local_database(branch = target_branch)
      each_local_config do |config|
        yield BranchSwitcher.create(config, branch)
      end
    end

    class BranchSwitcher
      def self.create(config, branch)
        case config['adapter']
        when /sqlite/
          SqliteSwitcher.new(config, branch)
        else
          $stderr.puts 'Your database adapter is not supported yet.'
          BranchSwitcher.new(config, branch)
        end
      end
      
      def initialize(config, branch)
        @config, @branch = config, branch
      end

      def current
      end
      
      def create_initial
      end
      
      def copy_from(other_branch)
      end
      
      def link_to(other_branch)
      end
      
      def select
      end
      
      def delete
      end
    end
    
    class SqliteSwitcher < BranchSwitcher
      def initialize(config, branch)
        super
        @db, @branch_db = db_path, branch_db_path
      end
      
      def current
        puts "#{relative_path(@db)} -> #{relative_path(@branch_db)}"
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
        if File.exist?(@branch_db) && !File.symlink?(@branch_db)
          $stderr.puts "A database file #{@branch_db} exists already."
        elsif File.exist?(other_db)
          make_branch_dir
          ### TODO make sure that symlinks are copied as symlinks
          FileUtils.cp(other_db, @branch_db)
        end
      end

      def link_to(other_branch)
        ### TODO
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
        File.join(RAILS_ROOT, 'db', 'branches', branch)
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
        s.sub(%r{^#{RAILS_ROOT}/db/}, '')
      end
    end
  end
end
