if defined?(RSpec::Core::RakeTask)
  RSpec::Core::RakeTask.new 'docs:generate:append', :spec_file do |t, task_args|
    ENV['DOC_FORMAT'] = 'append_json' if task_args[:spec_file].present?
    t.pattern = task_args[:spec_file] || 'spec/requests/**/*_spec.rb'
    t.rspec_opts = ['--format RspecApiDocumentation::ApiFormatter']
  end
end
