
require 'branch_db'

module BranchDB # :nodoc
  module ConfigurationTwiddler
    
    def self.included(base)
      base.send(:alias_method, :database_configuration_without_branches, :database_configuration)
      base.send(:alias_method, :database_configuration, :database_configuration_with_branches)
    end

    def database_configuration_with_branches
      dbconfig = database_configuration_without_branches
      if branch = BranchDB::current_repo_branch
        dbconfig.each do |env, config|
          BranchDB::Switcher.create(config, branch, env).switch!
        end
      end
      dbconfig
    end
  end
end
