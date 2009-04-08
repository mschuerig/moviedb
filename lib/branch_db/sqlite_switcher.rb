
require 'branch_db/switcher'

module BranchDB # :nodoc:

  class SqliteSwitcher < Switcher
    
    def self.can_handle?(config)
      (config['adapter'] =~ /^sqlite/) == 0
    end

    def current
      current_branch = branch_db_exists?(@branch) ? @branch : 'master'
      puts "#{@rails_env}: #{rails_root_relative(branch_db(current_branch))} (SQLite)"
    end
    
    protected
    
    def self.show_branches(rails_env, config)
      super
    end

    def branch_db(branch)
      relative_path =
        if branch == 'master'
          @config['database']
        else
          @config['database'].sub(/(.+)\./, "\\1_#{branch}.")
        end
      File.join(RAILS_ROOT, relative_path)
    end
    
    def branch_db_exists?(branch)
      File.exist?(branch_db(branch))
    end
    
    def create_database(branch)
      config = branch_config(branch)
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection
    end
    
    def drop_database(branch)
      FileUtils.rm_f(branch_db(branch))
    end

    def copy_database(from_branch, to_branch)
      FileUtils.cp(branch_db(from_branch), branch_db(to_branch))
    end
    
    private
    
    def rails_root_relative(p)
      p.sub(%r{^#{RAILS_ROOT}/}, '')
    end
  end
end
