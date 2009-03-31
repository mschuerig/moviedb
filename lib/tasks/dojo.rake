
namespace :dojo do
  
  task :setup => :environment do
    DOJO_ROOT = File.join(RAILS_ROOT, 'vendor', 'dojo')
    DOJO_BUILD = File.join(DOJO_ROOT, 'util', 'buildscripts')
    DOJO_PROFILES = File.join(RAILS_ROOT, 'config', 'dojo_profiles')
    DOJO_RELEASES = File.join(RAILS_ROOT, 'public')
    profile = ENV['PROFILE'] || 'production'
    if profile == 'development' && ENV['FORCE'] != 'true'
      $stderr.puts "Think again! You may be trying to overwrite your source files. If you are sure, set FORCE=true"
      exit
    end
    profile_file = File.join(DOJO_PROFILES, "#{profile}.js")
    unless File.exist?(profile_file)
      $stderr.puts "The profile #{profile} does not exist."
      exit
    end
  end
  
  desc 'Build a dojo profile. Default is production, can be set with PROFILE'
  task :optimize => "dojo:setup" do
    release_dir = File.join(DOJO_RELEASES, "javascripts.#{profile}", '/')
    release_name = ''
    sh %{cd "#{DOJO_BUILD}" && ./build.sh action=clean,release profileFile="#{profile_file}" releaseDir="#{release_dir}" releaseName="#{release_name}" cssOptimize=comments.keepLines}
  end
  
  namespace :optimize do
    task :all => "dojo:setup" do
      puts "Not yet implemented..."
    end
    
    task :stylesheets do
      puts "Not yet implemented..."
    end
  end
end
