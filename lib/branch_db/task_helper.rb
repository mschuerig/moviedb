
require 'branch_db/switcher'
require 'branch_db/postgresql_switcher'
require 'branch_db/sqlite_switcher'

module BranchDB # :nodoc:
  module TaskHelper

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
      ActiveRecord::Base.configurations.each do |rails_env, config|
        next unless config['database']
        next unless config['per_branch']
        local_database?(config) do
          yield rails_env, config
        end
      end
    end
    
    def each_local_database(*args)
      options = args.last.kind_of?(Hash) ? args.pop : {}
      options = options.reverse_merge(environment_options)
      branch = args[0] || target_branch
      each_local_config do |rails_env, config|
        yield BranchDB::Switcher.create(config, branch, rails_env, options)
      end
    end
  end
end
