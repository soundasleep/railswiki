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
  get "/auth/google_login" => "railswiki/sessions#create", as: :login
end
```

Install and run migrations:

```bash
$ rake railties:install:migrations
$ rake db:migrate
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
```

Set your secrets in a `.env` file in root (using `dotenv-rails`):

```yaml
OAUTH_CLIENT_ID: "xyz"
OAUTH_CLIENT_SECRET: "xyz"
```

Get these values by [logging into your Google Developers Console](http://www.jevon.org/wiki/Google_OAuth2_with_Ruby_on_Rails).

You can now host locally and visit http://localhost:3000/wiki:

```bash
$ rails s
```

## Extending

In your local app, edit the app/assets/javascripts/ and app/assets/stylesheets as normal.
They will automatically be picked up.

You can also override individual views from _railswiki_ by creating e.g. `app/views/railswiki/pages/show.html.erb`.

## Supported

1. Making pages, editing pages
1. Assigning permissions to users
1. Uploading files and images

## MVP

1. Create new users or invite users
1. Existing image widget in wysiwyg editor
1. Existing file widget in wysiwyg editor

## TODO

1. All the schemas require null set
1. Rspec tests
2. Cucumber tests
3. Travis-ci integration
4. Demo site
5. Screenshot
6. A nice default style

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
