
require 'active_support'

module BranchDB # :nodoc
  module ConfigurationTwiddler
    extend ::ActiveSupport::Memoizable
    
    DEFAULT_BRANCH = 'master'
    
    class BranchDBError < StandardError; end
    
    def self.included(base)
      base.alias_method_chain :database_configuration, :branches
    end

    def database_configuration_with_branches
      dbconfig = database_configuration_without_branches
      if current_repo_branch
        dbconfig.each do |env, conf|
          case per_branch = conf['per_branch']
          when DEFAULT_BRANCH
            # use conf['database'] as is
          when true
            branch_db = branch_db_name(conf['database'], env, current_repo_branch)
            if database_exists?(conf['adapter'], conf['username'], branch_db)
              conf['database'] = branch_db 
            end
          when Hash
            if branch_db = per_branch[current_repo_branch]
              conf['database'] = branch_db
              # Don't check for existence. A missing DB is an error -- just blow up.
            end
          end
        end
      end
      dbconfig
    end
    
    private
    
    def current_repo_branch
      raw = `git rev-parse --symbolic-full-name HEAD`
      if $? == 0
        raw.sub(%r{^refs/heads/}, '').chomp
      else
        # Don't raise an exception. We might be running in an exported copy.
        $stderr.puts %{Unable to determine the current repository branch, assuming "#{DEFAULT_BRANCH}".}
        DEFAULT_BRANCH
      end
    end
    memoize :current_repo_branch
    
    def branch_db_name(main_db_name, env, branch)
      main_db_name.sub(/(_.+?)??(_?(#{env}))?$/, "_#{branch}\\2")
    end
    
    def database_exists?(adapter, user, database)
      case adapter
      when /^sqlite/
        File.exists?(File.join(RAILS_ROOT, db))
      else
        existing_databases(adapter, user).include?(database)
      end
    end
    
    def existing_databases(adapter, user)
      case adapter
      when 'mysql'
        raw_dbs = `mysql -u "#{user}" -e "SHOW DATABASES"`
        if $? == 0
          existing_dbs = raw_dbs.split("\n")[1..-1]
          existing_dbs.reject { |db| db == 'information_schema' }
        else
          ### TODO error handling
          false
        end
      when 'postgresql'
        raw_dbs = `psql -l 2> /dev/null`
        if $? == 0
          existing_dbs = raw_dbs.split("\n").drop_while { |l| l !~ /^-/ }.drop(1).take_while { |l| l !~ /^\(/ }.map { |l| l.split('|')[0].strip }
          existing_dbs.reject { |db| db =~ /^template/ }
        else
          ### TODO error handling
          false
        end
      end
    end
    memoize :existing_databases
  end
end

