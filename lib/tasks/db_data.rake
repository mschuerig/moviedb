
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
    
    load_fixtures(File.join(RAILS_ROOT, 'spec', 'fixtures'))
    ActiveRecord::Base.transaction do
      DbUtils::IndexLifter.without_indexes do
        MovieDb::Populator.new(people_count, movies_count).populate
      end
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
