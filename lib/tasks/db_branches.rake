
require 'ruby-debug' ### REMOVE

namespace :db do
  
  task :branches => "branches:list"

  namespace :branches do
    
    task :setup => "db:load_config" do
      require 'branch_db/task_helper'
      include BranchDB::TaskHelper
    end
    
    desc "List all branch databases"
    task :list => :setup do
      puts BranchDB::Switcher.which.branches
    end
    
    desc "Currently selected databases."
    task :current => :setup do
      each_local_database { |switcher| switcher.current }
    end

    #desc "Create an empty database for a branch"
    task :create => :setup do
      ### TODO
    end
    
    desc "Copy databases from one branch to another. Default is from ORIG_BRANCH=master to BRANCH=<current branch>"
    task :copy => :setup do
      if originating_branch == current_branch
        $stderr.puts "Cannot copy database to itself."
      else
        each_local_database { |switcher| switcher.copy_from(originating_branch) }
      end
    end

    desc "Delete databases for a branch given by BRANCH"
    task :delete => :setup do
      case target_branch
      when current_branch
        $stderr.puts "Cannot delete databases for the current branch."
      when 'master'
        $stderr.puts "Cannot delete databases for the master branch."
      else
        each_local_database { |switcher| switcher.delete_database }
      end
    end
    
    #desc "Show sizes of all branch databases"
    task :size do
      ### TODO
    end
    
  end
end
