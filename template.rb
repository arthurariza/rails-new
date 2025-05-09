def git_add_and_commit(message)
  git add: "."
  git commit: "-m '#{message}'"
end

git_add_and_commit "Initial commit"

gem_group :development, :test do
  gem "bullet"
  gem "dotenv-rails"
  gem "faker"
  gem "rspec-rails"
  gem "factory_bot_rails"
end

git_add_and_commit "Add development and test gems"

ruby_ui = yes?("Do you want to use ruby_ui? (y/n)")

gem_group :development do
  gem "hotwire-spark" if yes?("Do you want to use hotwire-spark? (y/n)")
  gem "htmlbeautifier" if yes?("Do you want to use htmlbeautifier? (y/n)")
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "rubocop-factory_bot"
  gem "ruby_ui", require: false if ruby_ui
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

  generate "bullet:install"
  git_add_and_commit "Install Bullet"

  if ruby_ui
    generate "ruby_ui:install"
    git_add_and_commit "Install Ruby UI"
  end

  # create directories and files
  run "mkdir spec/factories"
  run "mkdir app/services"
  run "touch app/services/.keep .rubocop.yml .env .env.template"
  git_add_and_commit "Create directories and files"

  # copy new files that should always be in project
  copy_file File.expand_path("../files/.rubocop.yml", __FILE__), ".rubocop.yml"
  copy_file File.expand_path("../files/application_service.rb", __FILE__), "app/services/application_service.rb"
  git_add_and_commit "Copy files"

  if yes?("Do you want to use authentication? (y/n)")
    generate(:authentication)
    route "root to: 'sessions#new'"
    git_add_and_commit "Generate authentication"
    # TODO: Fix error factory_bot [not found] when running `rails g authentication`
  end

  if yes?("Do you want to use Active Storage? (y/n)")
    rails_command "active_storage:install"
    git_add_and_commit "Install Active Storage"
  end

  run "rails db:prepare"
  git_add_and_commit "Prepare database"

  run "rm -rf files/"
  run "rm railsrc"
  run "rm template.rb"
  run "rm bin/rails-new"
  append_to_file ".gitignore", "\n!.env.template\n"
  git_add_and_commit "Cleanup"

  run "bundle exec rubocop -a"
  git_add_and_commit "Rubocop auto-correct"
end
