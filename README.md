# Rails 8 + Vite Ruby App Creator

A template for creating new Rails applications with Vite and a pre-configured set of gems and tools.

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
--skip-jbuilder
--skip-test
--skip-rubocop
```

These options configure your Rails application with:
- SQLite database
- Tailwind CSS for styling
- Vite as the JavaScript and asset bundler
- Inertia.js for modern SPA-like navigation
- TypeScript and Prettier for improved developer experience
- Skips JBuilder
- Skips default test framework (uses RSpec instead)

> **Note:** You can customize these options by modifying the `railsrc` file before running the script. Feel free to add or remove options based on your project's specific needs.

## Included Gems & Tools

This template installs and configures the following gems and tools:

### Development & Test

- **rspec-rails** - Testing framework
- **factory_bot_rails** - Test data generation
- **faker** - Fake data generation for tests
- **dotenv-rails** - Environment variable management
- **bullet** - N+1 query detection

### Development Only

- **vite_rails** - Integrates Vite for asset bundling
- **inertia_rails** - Inertia.js adapter for Rails
- **typescript** - TypeScript support via Vite
- **prettier** - Code formatter for JavaScript/TypeScript
- **htmlbeautifier** - (Optional) HTML ERB beautifier
- **rubocop** - Ruby linter, configured with Shopify rules
- **rubocop-shopify** - Shopify specific code style checking

### Test Only

- **shoulda-matchers** - Test matchers for common Rails functionality

## Features

- Vite-powered frontend with TypeScript and Prettier
- Inertia.js for SPA-like navigation
- Configures RSpec with FactoryBot and Shoulda Matchers
- Sets up Bullet for N+1 query detection
- Creates a services directory with Rails autoloading
- Includes a pre-configured Rubocop setup using Shopify rules
- Optional authentication setup
- Optional Active Storage setup
- Creates common files like .env and .env.template
## Thanks

Based on [this blog post](https://danielabaron.me/blog/kickstart-a-new-rails-project/#rubocop), [this repository](https://github.com/CodingItWrong/apiup/tree/main), [official Rails template guide](https://guides.rubyonrails.org/rails_application_templates.html), and [Ruby On Whales](https://github.com/evilmartians/ruby-on-whales)

## License

This project is available as open source under the terms of the [MIT License](LICENSE).
