# Rails 8+ App Creator

A template for creating new Rails applications with a pre-configured set of gems and tools.

## Usage
Create a new directory with the name of your project and change directory into it.

```
mkdir project_name && cd project_name
```

Clone this repository into the directory
```
git clone git@github.com:arthurariza/rails-new.git .
```

Run the script
```
bin/rails-new
```

## Default Configuration

This template uses the following Rails configuration options:

```
--database=sqlite3
--javascript=esbuild
--css=tailwind
--skip-jbuilder
--skip-spring
--skip-bootsnap
--skip-test
```

These options configure your Rails application with:
- SQLite database
- Tailwind CSS for styling
- ESBuild for JavaScript
- Skips JBuilder
- Skips Spring application preloader
- Skips Bootsnap application booter
- Skips default test framework (uses RSpec instead)

> **Note:** You can customize these options by modifying the `railsrc` file before running the script. Feel free to add or remove options based on your project's specific needs.

## Included Gems

This template installs and configures the following gems:

### Development & Test

- **rspec-rails** - Testing framework
- **factory_bot_rails** - Test data generation
- **faker** - Fake data generation for tests
- **dotenv-rails** - Environment variable management
- **bullet** - N+1 query detection

### Development Only

- **hotwire-spark** - (Optional) Hotwire development tools
- **rubocop-rspec** - RSpec specific code style checking
- **rubocop-thread_safety** - Thread safety code style checking
- **rubocop-factory_bot** - FactoryBot specific code style checking

### Test Only

- **shoulda-matchers** - Test matchers for common Rails functionality

## Features

- Configures RSpec with FactoryBot and Shoulda Matchers
- Sets up Bullet for N+1 query detection
- Creates a services directory with Rails autoloading
- Includes a pre-configured Rubocop setup
- Optional authentication setup
- Optional Active Storage setup
- Creates common files like .env and .env.template

## Thanks

Based on [this blog post](https://danielabaron.me/blog/kickstart-a-new-rails-project/#rubocop), [this repository](https://github.com/CodingItWrong/apiup/tree/main), and [official Rails template guide](https://guides.rubyonrails.org/rails_application_templates.html)

## License

This project is available as open source under the terms of the [MIT License](LICENSE).
