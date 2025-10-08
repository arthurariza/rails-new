def git_add_and_commit(message)
  git add: "."
  git commit: "-m '#{message}'"
end

def remove_file(file_name)
  run "rm #{file_name}"
end

def remove_dir(dir_name)
  run "rm -rf #{dir_name}"
end

git_add_and_commit "Initial commit"

if yes?("Would you like to install Devise?")
  gem "devise"
  devise_model = ask("What would you like the user model to be called?", default: "User")
  git_add_and_commit "Add devise gem"
end

gem "pundit"
git_add_and_commit "Add pundit gem"

gem "pagy"
git_add_and_commit "Add pagy gem"

gem_group :development, :test do
  gem "bullet"
  gem "dotenv-rails"
  gem "faker"
  gem "factory_bot_rails"
  gem "rspec-rails"
end

git_add_and_commit "Add development and test gems"

gem_group :development do
  gem "hotwire-spark"
  gem "htmlbeautifier" if yes?("Install htmlbeautifier? (y/n)", :green)
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem "rubocop-thread_safety", require: false
  gem 'tidewave'
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

  generate "pundit:install"
  git_add_and_commit "Install Pundit"

  insert_into_file "app/controllers/application_controller.rb", "\n  include Pagy::Backend", after: "ActionController::Base"
  insert_into_file "app/helpers/application_helper.rb", "\n  include Pagy::Frontend", after: "ApplicationHelper"
  git_add_and_commit "Install Pagy"
  
  generate "bullet:install"
  git_add_and_commit "Install Bullet"
  
  # create directories and files
  run "mkdir spec/factories"
  run "touch app/services/.keep"
  git_add_and_commit "Create directories and files"
  
  if devise_model
    generate "devise:install"
    generate "devise", devise_model
    generate "devise:views"
    
    insert_into_file "config/environments/development.rb", "\n  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n", after: "do"

    git_add_and_commit "Devise install"
  end

  if !devise_model && yes?("Generate authentication? (y/n)", :green)
    generate(:authentication)
    route "root to: 'sessions#new'"
    generate "factory_bot:model user email password"
    git_add_and_commit "Generate authentication"
  end

  append_to_file ".gitignore", "\n!.env.template\n"
  git_add_and_commit "Add .env.template to .gitignore"

  if yes?("Pull ai-context? (y/n)", :blue)
    git clone: "--depth 1 https://github.com/arthurariza/rails-ai-context.git .ai"
    run "rm -rf .ai/.git"
    append_to_file ".gitignore", "\n.ai/\n"
    git_add_and_commit "Vendor ai-context into .ai"
  end

  if yes?("Remove the template files? (y/n)", :red)
    remove_file "railsrc"
    remove_file "template.rb"
    remove_file "Build.dockerfile"
    remove_file "bin/rails-new"
    remove_file "bin/rails-new-docker"
    git_add_and_commit "Cleanup"
  end

  run "bundle binstubs rubocop"
  run "bin/rubocop -A || true"
  git_add_and_commit "Rubocop auto-correct"

  run "bin/rails db:prepare"
  git_add_and_commit "Prepare database"
end
