
desc 'Restart passenger hosted app.'
task :restart => :environment do
  sh %{touch "#{RAILS_ROOT}/tmp/restart.txt"}
end

namespace :restart do
  task :debug do
    sh %{echo wait > "#{RAILS_ROOT}/tmp/debug.txt"}
    sh %{touch "#{RAILS_ROOT}/tmp/restart.txt"}
  end
end
