# Railswiki
A wiki engine in Rails 5.

## Usage
TODO How to use my plugin.

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
1. Uploading files and images, images can be scaled and linked to external URLs
1. Existing image dialog in wysiwyg editor (uploading images remotely is too hard)
1. Existing file dialog in wysiwyg editor
1. Invite users
1. Prevent navigating/reloading with unsaved changes
1. Templates can be included using `{{template}}`
1. Search with `{{Special:Search}}` template
1. Rails 5.1

## MVP

1. A nice default style
1. Include Javascript libraries through an asset pipeline, rather than through http
1. Put dialog Javascript into assets/, not inline
1. When login fails, redirect to an error page, not 500

## TODO

1. Use yarn/webpack for Javascript assets
1. All the schemas require null set
1. Rspec tests
2. Cucumber tests
3. Travis-ci integration
4. Demo site on Heroku
5. Screenshot
1. Uploads [persist across validations](https://github.com/carrierwaveuploader/carrierwave#making-uploads-work-across-form-redisplays) and can be [uploaded from remote URLs](https://github.com/carrierwaveuploader/carrierwave#uploading-files-from-a-remote-location)
1. Support [strikethrough, pretty code blocks, etc](https://github.com/vmg/redcarpet) and list in Special:Formatting
1. Example Special:Formatting page with full supported syntax
1. "What Links Here"
1. "Page Categories"

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
