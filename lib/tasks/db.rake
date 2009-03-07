
namespace :db do

  desc "Load reference data."
  task :load_reference_data => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'ref_data', '*.{yml,csv}'))).each do |fixture_file|
      Fixtures.create_fixtures('db/ref_data', File.basename(fixture_file, '.*'))
    end
  end
end
