# spec/support/shared_contexts/rake.rb
require 'rake'

shared_context 'rake' do
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/#{task_name.tr(':', '_')}.rake" }
  let(:subject)   { Rake::Task[task_name] }

  before(:all) do
    # See:
    # - https://content.pivotal.io/blog/test-your-rake-tasks
    # - https://robots.thoughtbot.com/test-rake-tasks-like-a-boss
    # load task
    Rake::Task.clear
    Rails.application.load_tasks
    Rake::Task.define_task(:environment)
  end

  before do
    DatabaseCleaner.clean_with :truncation
    subject.reenable
  end
end
