
set :application, "moviedb"
set :app_port, 3001
set :server_name, "localhost"
set :scm, :git
set :repository, "git@github.com:mschuerig/#{application}.git"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :branch, "master"
###set :base_path, "/var/www"
set :base_path, "/tmp"
set :deploy_to, "#{base_path}/#{application}"
set :apache_site_folder, "/etc/apache2/sites-enabled"
set :fs_user, 'www-data'
set :keep_releases, 3 

role :web, server_name
role :app, server_name
role :db,  server_name, :primary => true

default_run_options[:pty] = true

after "deploy:setup",       "deploy:set_permissions"
after "deploy",             "deploy:set_permissions"
after "deploy:update_code", "deploy:link_shared_configs"
after "deploy:update_code", "deploy:link_dojo"
after "deploy:update_code", "deploy:optimize_resources"

# Overrides for Phusion Passenger
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  task :set_permissions do
###    sudo "chown -R #{fs_user}:#{defined?(fs_group) ? fs_group : fs_user} '#{base_path}/#{application}'"
  end

  task :link_shared_configs, :roles => [:app] do
    %(database.yml).each do |f|
      run "ln -nsf '#{shared_path}/config/#{f}' '#{release_path}/config/#{f}'"
    end
  end

  task :link_dojo do
    run "ln -nsf '#{shared_path}/dojo' '#{release_path}/vendor'"
  end

  task :optimize_resources do
#    run "cd '#{release_path}' && rake dojo:optimize dojo:use:optimized RAILS_ENV=production"
  end
end

namespace :init do

  desc "Create database"
  task :create_database do
### -> rake db:create:all
  end

  desc "Install gems"
  task :install_gems do
    sudo "cd '#{current_path}' && rake gems:install"
  end
  
  desc "Install Dojo"
  task :install_dojo do
    ### TODO download a release or SVN tag?
  end

  desc "enable site"
  task :enable_site do
###    sudo "ln -nsf '#{shared_path}/config/apache_site.conf' '#{apache_site_folder}/#{application}'"
### apache2ctl graceful
  end

  desc "Create database.yml"
  task :database_yml do
    set :db_user, Capistrano::CLI.ui.ask("database user: ")
    set :db_pass, Capistrano::CLI.password_prompt("database password: ")
    database_configuration = %{
login: &login
  username: #{db_user}
  password: #{db_pass}

production:
  <<: *login
  adapter: postgresql
  database: #{application}_production
  host: localhost
  port: 5432
}
    run "mkdir -p '#{shared_path}/config'"
    put database_configuration, "#{shared_path}/config/database.yml"
  end

  desc "create vhost file"
  task :create_vhost do
    vhost_configuration = %{
Listen #{app_port}

<VirtualHost *:#{app_port}>
  DocumentRoot #{base_path}/#{application}/current/public
  RailsEnv production
  PassengerHighPerformance on
</VirtualHost>
}

    run "mkdir -p #{shared_path}/config"
    put vhost_configuration, "#{shared_path}/config/apache_site.conf"
  end

end
