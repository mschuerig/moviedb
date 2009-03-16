
namespace :db do
  namespace :branches do
    
    desc "Initialize per branch databases."
    task :init => "db:load_config" do
      each_local_database { |config| init_branch(config, current_branch) }
    end
    
    desc "Switch to the DB for the currently checked out git branch."
    task :switch => "db:load_config" do
      each_local_database { |config| switch_branch(config, current_branch) }
    end

    desc "Copy databases for a new branch."
    task :copy => "db:load_config" do
      from_branch = ENV['FROM_BRANCH'] || 'master' ### FIXME determine originating branch
      to_branch = ENV['BRANCH'] || current_branch
      each_local_database { |config| copy_database(config, from_branch, to_branch) }
    end
  end

  def current_branch
    ENV['BRANCH'] || `git symbolic-ref HEAD`.sub(%r{^refs/heads/}, '').chomp
  end
  
  def each_local_database
    ActiveRecord::Base.configurations.each_value do |config|
      next unless config['database']
      local_database?(config) { yield config }
    end
  end

  def db_path(config)
    File.join(RAILS_ROOT, config['database'])
  end
  
  def branch_dir(branch)
    File.join(RAILS_ROOT, 'db', 'branches', branch)
  end
  
  def branch_db_path(config, branch)
    File.join(branch_dir(branch), File.basename(db_path(config)))
  end
  
  def ensure_branch_exists!(branch)
    unless File.directory?(branch_dir(branch))
      raise "There is no database for the branch #{branch}"
    end
  end
  
  def init_branch(config, branch)
    case config['adapter']
    when /sqlite/
      db, branch_db = db_path(config), branch_db_path(config, branch)
      FileUtils.mkdir_p(File.dirname(branch_db))
      unless File.exist?(branch_db)
        FileUtils.mv(db, branch_db) if File.exist?(db)
        FileUtils.ln_s(branch_db, db)
      end
    else
      puts 'sorry, your database adapter is not supported yet, feel free to submit a patch'
    end
  end
  
  def copy_database(config, from_branch, to_branch)
    case config['adapter']
    when /sqlite/
      from_db = branch_db_path(config, from_branch)
      to_db = branch_db_path(config, to_branch)
      if File.exist?(to_db)
        $stderr.puts "A database file #{to_db} exists already."
      elsif File.exist?(from_db)
        FileUtils.mkdir_p(File.dirname(to_db))
        FileUtils.cp(from_db, to_db)
      end
    else
      puts 'sorry, your database adapter is not supported yet, feel free to submit a patch'
    end
  end

  def switch_branch(config, branch)
    ensure_branch_exists!(branch)
    case config['adapter']
    when /sqlite/
      FileUtils.ln_sf(
        branch_db_path(config, branch),
        db_path(config)
      )
    else
      puts 'sorry, your database adapter is not supported yet, feel free to submit a patch'
    end
  end

end
