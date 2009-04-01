
require 'fileutils'

namespace :db do
  namespace :dump do

    desc 'Dump the database, structure and data, for the current RAILS_ENV to SQL.'
    task :all => :environment do
      dump_file = File.join(RAILS_ROOT, 'db', "#{RAILS_ENV}-full-dump-#{Time.now.strftime('%Y%m%d%H%M')}.sql")
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      case config['adapter']
      when 'mysql'
        `mysqldump --user "#{config["username"]}" --host "#{config["host"]}" #{config["database"]} > #{dump_file}`
      when 'postgresql'
        `pg_dump --clean --inserts -U "#{config["username"]}" --host="#{config["host"]}" --port=#{config['port']} #{config["database"]} > #{dump_file}`
      else
        raise "Don't know how to dump a #{config['adapter']} database."
      end
    end

    desc 'Dump the database, data only, for the current RAILS_ENV to SQL.'
    task :data => :environment do
      dump_file = File.join(RAILS_ROOT, 'db', "#{RAILS_ENV}-data-dump-#{Time.now.strftime('%Y%m%d%H%M')}.sql")
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      case config['adapter']
      when 'mysql'
        `mysqldump --no-create-info --user "#{config["username"]}" --host "#{config["host"]}" #{config["database"]} > #{dump_file}`
      when 'postgresql'
        `pg_dump --data-only --inserts -U "#{config["username"]}" --host="#{config["host"]}" --port=#{config['port']} #{config["database"]} > #{dump_file}`
      else
        raise "Don't know how to dump a #{config['adapter']} database."
      end
    end
  end
end

