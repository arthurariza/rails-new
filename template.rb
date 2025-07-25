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

gem "vite_rails"
git_add_and_commit "Add vite_rails gem"

gem_group :development, :test do
  gem "bullet"
  gem "dotenv-rails"
  gem "faker"
  gem "factory_bot_rails"
  gem "rspec-rails"
end

git_add_and_commit "Add development and test gems"

gem_group :development do
  gem "htmlbeautifier" if yes?("Do you want to use htmlbeautifier? (y/n)", :green)
  gem "rubocop", require: false
  gem "rubocop-shopify", require: false
end

git_add_and_commit "Add development gems"

gem_group :test do
  gem "shoulda-matchers", require: false
end

git_add_and_commit "Add test gems"

# adds lines to `config/application.rb`
environment 'config.autoload_paths << Rails.root.join("services")'

# commands to run after `bundle install`
after_bundle do
  run "bundle exec vite install"
  run "bun add -D vite-plugin-full-reload vite-plugin-stimulus-hmr prettier tailwindcss @tailwindcss/vite @tailwindcss/forms @tailwindcss/typography"
  insert_into_file "app/views/layouts/application.html.erb","\n    <%= vite_stylesheet_tag 'application' %>" , after: "<%= vite_client_tag %>"
  gsub_file "app/views/layouts/application.html.erb",'<%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>' , ""
  gsub_file "app/views/layouts/application.html.erb",'<%= javascript_include_tag "application", "data-turbo-track": "reload", type: "module" %>' , ""
  gsub_file "app/views/layouts/application.html.erb",'<%# Includes all stylesheet files in app/assets/stylesheets %>' , ""
  insert_into_file "vite.config.mts","\nserver: {allowedHosts: ['vite']}" , after: "],"
  insert_into_file "vite.config.mts","\nFullReload(['config/routes.rb', 'app/views/**/*']),\nStimulusHMR(),\ntailwindcss()," , after: "plugins: ["
  prepend_to_file "vite.config.mts", "import FullReload from 'vite-plugin-full-reload';\n"
  prepend_to_file "vite.config.mts", "import StimulusHMR from 'vite-plugin-stimulus-hmr';\n"
  prepend_to_file "vite.config.mts", "import tailwindcss from '@tailwindcss/vite';\n"
  git_add_and_commit "Install Vite, Plugins and Tailwind"

  append_to_file "app/javascript/entrypoints/application.js", "import * as Turbo from '@hotwired/turbo'\nTurbo.start();\nimport '../controllers'\n"
  git_add_and_commit "Install Turbo and Stimulus"

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

  # create directories and files
  run "mkdir spec/factories"
  run "touch app/services/.keep"
  git_add_and_commit "Create directories and files"

  if yes?("Do you want to use authentication? (y/n)", :green)
    generate(:authentication)
    route "root to: 'sessions#new'"
    generate "factory_bot:model user email password"
    git_add_and_commit "Generate authentication"
  end

  if yes?("Do you want to use Active Storage? (y/n)", :green)
    rails_command "active_storage:install"
    git_add_and_commit "Install Active Storage"
  end

  append_to_file ".gitignore", "\n!.env.template\n"
  git_add_and_commit "Add .env.template to .gitignore"

  if yes?("Do you want to remove the template files? (y/n)", :red)
    remove_file "railsrc"
    remove_file "template.rb"
    remove_file "Build.dockerfile"
    remove_file "bin/rails-new"
    remove_file "bin/rails-new-docker"
    git_add_and_commit "Cleanup"
  end

  run "bun prettier --write . || true"
  git_add_and_commit "Prettier auto-correct"

  run "bundle binstubs rubocop"
  run "bin/rubocop -a || true"
  git_add_and_commit "Rubocop auto-correct"

  run "bin/rails db:prepare"
  git_add_and_commit "Prepare database"
end
