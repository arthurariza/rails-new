def git_add_and_commit(message)
  git add: "."
  git commit: "-m #{message}"
end

git :init
git_add_and_commit "Initial commit"

gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "dotenv-rails"
end

git_add_and_commit "Add development and test gems"

gem_group :development do
  gem "bullet"
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "rubocop-factory_bot"
end

git_add_and_commit "Add development gems"

gem_group :test do
  gem "shoulda-matchers"
end

git_add_and_commit "Add test gems"

run "bundle install"
git_add_and_commit "Install gems"

# adds lines to `config/application.rb`
environment 'config.autoload_paths << Rails.root.join("services")'

# commands to run after `bundle install`
after_bundle do
  # setup RSpec testing
  run "bin/rails generate rspec:install"
  git_add_and_commit "Setup RSpec"

  # create directories and files
  run "mkdir app/services"
  run "touch app/services/.keep .rubocop.yml .env .env.template"
  git_add_and_commit "Create directories and files"

  # copy new files that should always be in project
  copy_file "files/.rubocop.yml", ".rubocop.yml"
  git_add_and_commit "Copy .rubocop.yml"
end

run "rails db:prepare"
git_add_and_commit "Prepare database"
