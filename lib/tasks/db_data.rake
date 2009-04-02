
namespace :db do

  desc "Load reference data."
  task :load_reference_data => :environment do
    load_fixtures(
      ENV['FIXTURE_PATH'] || File.join(RAILS_ROOT, 'db', 'ref_data'),
      ENV['FIXTURES'])
  end
  
  desc "Populate the database with sample data"
  task :populate => :environment do
    require 'machinist'
    require 'spec/blueprints'
    require 'db_utils/index_lifter'
    require 'movie_db/populator'
        
    people_count = (ENV['PEOPLE'] || 200).to_i
    movies_count = (ENV['MOVIES'] || 10).to_i
    
    retained_indexes = [
      ### FIXME AR botches column order; name is OK, schema.rb has wrong order
      'index_people_on_lastname_and_firstname_and_serial_number'
    ]
    
    load_fixtures(File.join(RAILS_ROOT, 'spec', 'fixtures'))
    ActiveRecord::Base.transaction do
      DbUtils::IndexLifter.without_indexes(:except => retained_indexes) do
        ActiveRecord::Base.silence do
          MovieDb::Populator.new(people_count, movies_count).populate
          puts "Whew... now let's get the indexes back..."
        end
      end
    end
    if ActiveRecord::Base.configurations[RAILS_ENV]['adapter'] == 'postgresql'
      puts "Finally, vacuum the database..."
      ActiveRecord::Base.connection.execute "VACUUM FULL ANALYZE"
    end
  end
  
  def load_fixtures(fixture_path, fixtures = nil)
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    fixtures ||= Dir.glob(File.join(fixture_path, '*.{yml,csv}'))
    fixtures.each do |file|
      Fixtures.create_fixtures(fixture_path, File.basename(file, '.*'))
    end
  end
  
end
