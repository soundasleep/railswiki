# Railswiki
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'railswiki'

# for loading secrets
gem 'figaro'
gem 'dotenv-rails'
```

And then execute:
```bash
$ bundle
```

Then enable in your application in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount Railswiki::Engine, at: "/wiki"

  get "/auth/google_login/callback" => "railswiki/sessions#create"
end
```

Install and run migrations:

```bash
$ rails railties:install:migrations
$ rails db:migrate
```

Enable `config/secrets.yml` to load secrets from ENV (using `figaro`):

```yaml
# config/secrets.yml

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  OAUTH_CLIENT_ID: <%= ENV["OAUTH_CLIENT_ID"] %>
  OAUTH_CLIENT_SECRET: <%= ENV["OAUTH_CLIENT_SECRET"] %>
  # TODO is this actually necessary?
  APPLICATION_CONFIG_SECRET_TOKEN: <%= ENV["APPLICATION_CONFIG_SECRET_TOKEN"] %>
```

Set your secrets in a `.env` file in root (using `dotenv-rails`):

```yaml
OAUTH_CLIENT_ID: "xyz"
OAUTH_CLIENT_SECRET: "xyz"
APPLICATION_CONFIG_SECRET_TOKEN: "<A LONG SECRET>"
```

Get these values by [logging into your Google Developers Console](http://www.jevon.org/wiki/Google_OAuth2_with_Ruby_on_Rails).

You can now host locally and visit http://localhost:3000/wiki:

```bash
$ rails s
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
