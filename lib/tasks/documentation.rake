
namespace :doc do
  desc "Generate documentation for the application. Set custom template with TEMPLATE=/path/to/rdoc/template.rb or title with TITLE=\"Custom Title\""
  Rake::RDocTask.new("app") { |rdoc|
    require 'sdoc'

    rdoc.rdoc_dir = 'doc/app'
    rdoc.template = ENV['template'] if ENV['template']
    rdoc.title    = ENV['title'] || "Rails Application Documentation"
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.options << '--charset' << 'utf-8'
    rdoc.options << '--fmt' << 'shtml'
    rdoc.rdoc_files.include('doc/README_FOR_APP')
    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
  }

  desc "Generate documentation for the Rails framework"
  Rake::RDocTask.new("rails") { |rdoc|
    require 'sdoc'

    rdoc.rdoc_dir = 'doc/api'
    rdoc.template = "#{ENV['template']}.rb" if ENV['template']
    rdoc.title    = "Rails Framework Documentation"
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.options << '--fmt' << 'shtml'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('vendor/rails/railties/CHANGELOG')
    rdoc.rdoc_files.include('vendor/rails/railties/MIT-LICENSE')
    rdoc.rdoc_files.include('vendor/rails/railties/README')
    rdoc.rdoc_files.include('vendor/rails/railties/lib/{*.rb,commands/*.rb,rails_generator/*.rb}')
    rdoc.rdoc_files.include('vendor/rails/activerecord/README')
    rdoc.rdoc_files.include('vendor/rails/activerecord/CHANGELOG')
    rdoc.rdoc_files.include('vendor/rails/activerecord/lib/active_record/**/*.rb')
    rdoc.rdoc_files.exclude('vendor/rails/activerecord/lib/active_record/vendor/*')
    rdoc.rdoc_files.include('vendor/rails/activeresource/README')
    rdoc.rdoc_files.include('vendor/rails/activeresource/CHANGELOG')
    rdoc.rdoc_files.include('vendor/rails/activeresource/lib/active_resource.rb')
    rdoc.rdoc_files.include('vendor/rails/activeresource/lib/active_resource/*')
    rdoc.rdoc_files.include('vendor/rails/actionpack/README')
    rdoc.rdoc_files.include('vendor/rails/actionpack/CHANGELOG')
    rdoc.rdoc_files.include('vendor/rails/actionpack/lib/action_controller/**/*.rb')
    rdoc.rdoc_files.include('vendor/rails/actionpack/lib/action_view/**/*.rb')
    rdoc.rdoc_files.include('vendor/rails/actionmailer/README')
    rdoc.rdoc_files.include('vendor/rails/actionmailer/CHANGELOG')
    rdoc.rdoc_files.include('vendor/rails/actionmailer/lib/action_mailer/base.rb')
    rdoc.rdoc_files.include('vendor/rails/activesupport/README')
    rdoc.rdoc_files.include('vendor/rails/activesupport/CHANGELOG')
    rdoc.rdoc_files.include('vendor/rails/activesupport/lib/active_support/**/*.rb')
  }

end
