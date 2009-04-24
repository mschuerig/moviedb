
namespace :dojo do
  
  desc 'Update Dojo git repository.'
  task :update => :environment do
    DOJO_ROOT = File.join(RAILS_ROOT, 'vendor', 'dojo')
    Dir[File.join(DOJO_ROOT, '*')].each do |dir|
      sh %{cd "#{dir}" && git svn rebase && git gc}
    end
  end
  
  namespace :use do
    desc 'Use individual development script files.'
    task :debug => :environment do
      sh %{ln -nfs javascripts.development "#{RAILS_ROOT}/public/javascripts"}
    end
    desc 'Use optimized script files.'
    task :optimized => :environment do
      sh %{ln -nfs javascripts.production "#{RAILS_ROOT}/public/javascripts"}
    end
  end
  
  desc 'Build a dojo profile. Default is production, specify with PROFILE=<profile name>'
  task :optimize => "dojo:optimize:all"
  
  namespace :optimize do
    task :setup => :environment do
      DOJO_ROOT = File.join(RAILS_ROOT, 'vendor', 'dojo')
      DOJO_BUILD = File.join(DOJO_ROOT, 'util', 'buildscripts')
      DOJO_PROFILES = File.join(RAILS_ROOT, 'config', 'dojo_profiles')
      DOJO_RELEASES = File.join(RAILS_ROOT, 'public')
      DOJO_PROFILE = ENV['PROFILE'] || 'production'
      if DOJO_PROFILE == 'development' && ENV['FORCE'] != 'true'
        $stderr.puts "Think again! You may be trying to overwrite your source files. If you are sure, set FORCE=true"
        exit
      end
    end
  
    task :all => [:scripts, :stylesheets]
    
    desc 'Build a dojo profile. Default is production, specify with PROFILE=<profile name>'
    task :scripts => :setup do
      profile_file = File.join(DOJO_PROFILES, "#{DOJO_PROFILE}.js")
      unless File.exist?(profile_file)
        $stderr.puts "The profile #{DOJO_PROFILE} does not exist."
        exit
      end

      release_dir = File.join(DOJO_RELEASES, "javascripts.#{DOJO_PROFILE}", '/')
      release_name = ''
#      sh %{cd "#{DOJO_BUILD}" && ./build.sh action=clean,release profileFile="#{profile_file}" releaseDir="#{release_dir}" releaseName="#{release_name}" layerOptimize=shrinksafe.keepLines cssOptimize=comments.keepLines}
      sh %{cd "#{DOJO_BUILD}" && ./build.sh profileFile="#{profile_file}" releaseDir="#{release_dir}" releaseName="#{release_name}" }
    end

### TODO does the buildLayers option help?
#    task :stylesheets => :setup do
#      profile_file = File.join(DOJO_PROFILES, "stylesheets.js")
#      release_dir = File.join(DOJO_RELEASES, "stylesheets.#{DOJO_PROFILE}", '/')
#      release_name = ''
#      sh %{cd "#{DOJO_BUILD}" && ./build.sh action=release profileFile="#{profile_file}" releaseDir="#{release_dir}" releaseName="#{release_name}" layerOptimize=shrinksafe.keepLines cssOptimize=comments.keepLines}
#    end
  end
end
