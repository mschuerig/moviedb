
namespace :db do

  desc "Load reference data."
  task :load_reference_data => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    fixture_path = ENV['FIXTURE_PATH'] || File.join(RAILS_ROOT, 'db', 'ref_data')
    fixtures = 
      if ENV['FIXTURES']
        ENV['FIXTURES'].split(/,/)
      else
        Dir.glob(File.join(fixture_path, '*.{yml,csv}'))
      end
    fixtures.each do |file|
      Fixtures.create_fixtures(fixture_path, File.basename(file, '.*'))
    end
  end
  
  desc "Populate the database with sample data"
  task :populate => :environment do
    require 'machinist'
    require 'spec/blueprints'
        
    people_count = (ENV['PEOPLE'] || 200).to_i
    movies_count = (ENV['MOVIES'] || 10).to_i
    
    ENV['FIXTURE_PATH'] = File.join(RAILS_ROOT, 'spec', 'fixtures')
    Rake::Task['db:load_reference_data'].invoke
    
    ActiveRecord::Base.transaction do 
      puts "Creating movies..."
      people_count.times do
        Person.make
      end
      
      puts "Creating people..."
      movies_count.times do
        Movie.make
      end
      
      puts "Adding people to movies..."
      actors_max = [(people_count * 20)/movies, people_count].min
      Movie.find_each do |m|
        Person.find(:all, :order => 'random()', :limit => rand(actors_max)).each do |a|
          m.participants.add_actor(a)
        end
        m.participants.add_director(
          Person.find(:first, :order => 'random()', :limit => rand(actors_max)))
        m.save!
      end
      
      puts "Giving them awards..."
      years = Movie.connection.select_values('select distinct release_year from movies')
      years.each do |year|
        Award.all.each do |award|
          awarding = Awarding.new(:award => award)
          awarding.requirements.each do |assoc, count|
            awarding.movies = Movie.find(:all, 
              :conditions => { :release_year => year },
              :order => 'random()', :limit => count)
            awarding.people = Person.find(:all,
              :order => 'random()', :limit => count)
          end
          awarding.save!
        end
      end
    end
    
  end
end
