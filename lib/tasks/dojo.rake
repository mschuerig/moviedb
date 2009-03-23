
namespace :dojo do
  
  task :setup => :environment do
    DOJO_ROOT = File.join(RAILS_ROOT, 'vendor', 'dojo')
    DOJO_BUILD = File.join(DOJO_ROOT, 'util', 'buildscripts')
    DOJO_PROFILES = File.join(RAILS_ROOT, 'config', 'dojo_profiles')
    DOJO_RELEASES = File.join(RAILS_ROOT, 'public')
  end
  
  desc 'Build'
  task :build => "dojo:setup" do
    profileFile = File.join(DOJO_PROFILES, "#{RAILS_ENV}.js")
    releaseDir = File.join(DOJO_RELEASES, "javascripts.#{RAILS_ENV}", '/')
    releaseName = ''
    sh %{cd "#{DOJO_BUILD}" && ./build.sh action=clean,release profileFile="#{profileFile}" releaseDir="#{releaseDir}" releaseName="#{releaseName}" cssOptimize=comments.keepLines}
  end
  
  namespace :build do
    desc 'Build all'
    task :all => "dojo:setup" do
      puts "Not yet implemented..."
    end
  end
end
