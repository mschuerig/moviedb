
namespace :dojo do
  
  task :update => :environment do
    DOJO_ROOT = File.join(RAILS_ROOT, 'vendor', 'dojo')
    Dir[File.join(DOJO_ROOT, '*')].each do |dir|
      sh %{cd "#{dir}" && git svn rebase && git gc}
    end
  end
  
  task :setup => :environment do
    DOJO_ROOT = File.join(RAILS_ROOT, 'vendor', 'dojo')
    DOJO_BUILD = File.join(DOJO_ROOT, 'util', 'buildscripts')
    DOJO_PROFILES = File.join(RAILS_ROOT, 'config', 'dojo_profiles')
    DOJO_RELEASES = File.join(RAILS_ROOT, 'public')
    DOJO_PROFILE = ENV['PROFILE'] || 'production'
  end
  
  desc 'Build a dojo profile. Default is production, can be set with PROFILE'
  task :optimize => "dojo:setup" do
    if DOJO_PROFILE == 'development' && ENV['FORCE'] != 'true'
      $stderr.puts "Think again! You may be trying to overwrite your source files. If you are sure, set FORCE=true"
      exit
    end
    profile_file = File.join(DOJO_PROFILES, "#{DOJO_PROFILE}.js")
    unless File.exist?(profile_file)
      $stderr.puts "The profile #{DOJO_PROFILE} does not exist."
      exit
    end

    release_dir = File.join(DOJO_RELEASES, "javascripts.#{DOJO_PROFILE}", '/')
    release_name = ''
    sh %{cd "#{DOJO_BUILD}" && ./build.sh action=clean,release profileFile="#{profile_file}" releaseDir="#{release_dir}" releaseName="#{release_name}" layerOptimize=shrinksafe.keepLines cssOptimize=comments.keepLines}
  end
  
  namespace :optimize do
    task :all => "dojo:setup" do
      $stderr.puts "Not yet implemented..."
    end
    
    task :stylesheets do
      $stderr.puts "Not yet implemented..."
    end
  end
end
