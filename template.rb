def git_add_and_commit(message)
  git add: "."
  git commit: "-m '#{message}'"
end

git_add_and_commit "Initial commit"

gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "dotenv-rails"
  gem "bullet"
end

git_add_and_commit "Add development and test gems"

gem_group :development do
  gem "hotwire-spark" if yes?("Do you want to use hotwire-spark?")
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "rubocop-factory_bot"
end

git_add_and_commit "Add development gems"

gem_group :test do
  gem "shoulda-matchers"
end

git_add_and_commit "Add test gems"

# adds lines to `config/application.rb`
environment 'config.autoload_paths << Rails.root.join("services")'

# commands to run after `bundle install`
after_bundle do
  # setup RSpec testing
  run "bin/rails generate rspec:install"
  git_add_and_commit "Setup RSpec"

  # Configure FactoryBot and Shoulda Matchers in rails_helper.rb
  insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
    "  config.include FactoryBot::Syntax::Methods\n"
  end

  append_to_file "spec/rails_helper.rb" do
    "\nShoulda::Matchers.configure do |config|\n" +
    "  config.integrate do |with|\n" +
    "    with.test_framework :rspec\n" +
    "    with.library :rails\n" +
    "  end\n" +
    "end\n"
  end

  git_add_and_commit "Configure FactoryBot and Shoulda Matchers"

  run "bin/rails generate bullet:install"
  git_add_and_commit "Install Bullet"

  # create directories and files
  run "mkdir spec/factories"
  run "mkdir app/services"
  run "touch app/services/.keep .rubocop.yml .env .env.template"
  git_add_and_commit "Create directories and files"

  # copy new files that should always be in project
  copy_file File.expand_path("../files/.rubocop.yml", __FILE__), ".rubocop.yml"
  git_add_and_commit "Copy .rubocop.yml"

  if yes?("Do you want to use authentication?")
    generate(:authentication)
    git_add_and_commit "Generate authentication"
    # TODO: Fix error factory_bot [not found] when running `rails g authentication`
  end

  if yes?("Do you want to use Active Storage?")
    rails_command "active_storage:install"
    git_add_and_commit "Install Active Storage"
  end

  run "rails db:prepare"
  git_add_and_commit "Prepare database"

  run "rm -rf files/"
  run "rm railsrc"
  run "rm template.rb"
  run "rm bin/rails-new"
  git_add_and_commit "Cleanup"

  run "bundle exec rubocop -a"
  git_add_and_commit "Rubocop auto-correct"
end
