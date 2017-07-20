# Railswiki
A wiki engine in Rails 5.

## Usage

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

  root to: "railswiki/pages#show", id: "Home"
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
```

Set your secrets in a `.env` file in root (using `dotenv-rails`):

```yaml
SECRET_KEY_BASE: "xyz"
OAUTH_CLIENT_ID: "xyz"
OAUTH_CLIENT_SECRET: "xyz"
```

Get these values by [logging into your Google Developers Console](http://www.jevon.org/wiki/Google_OAuth2_with_Ruby_on_Rails).

Install webpacker, adding `railswiki` as a dependency:

```bash
$ rails webpacker:install
$ yarn add https://github.com/soundasleep/railswiki
$ yarn install
```

Add to your `app/javascript/packs/application.js`:

```js
// javascripts
import SimpleMDE from 'simplemde'
import Tingle from 'tingle.js'

window.SimpleMDE = SimpleMDE
window.tingle = Tingle

// stylesheets

// I have NO idea why the src/ is broken but debug/ works - it looks like src/
// is missing some extra styles that aren't being included properly. who knows.
// import "simplemde/src/css/simplemde.css"
import "simplemde/debug/simplemde.css"
import 'tingle.js/src/tingle.css'
```

Run `bin/webpack` or `bin/webpack-dev-server` (hot reloading) to compile the webpacker pack.

You can now host locally and visit http://localhost:3000/wiki:

```bash
$ rails s
```

## Extending

In your local app, edit the app/assets/javascripts/ and app/assets/stylesheets as normal.
They will automatically be picked up.

You can also override individual views from _railswiki_ by creating e.g. `app/views/railswiki/pages/show.html.erb`.

### Custom page titles

In `app/helpers/railswiki/title_helper.rb`:

```ruby
module Railswiki::TitleHelper
  def title(page_title)
    page_title = ["My Very First Wiki"] if page_title == ["Home"]

    content_for(:title) { page_title.join(" - ") }
  end
end
```

## Deploying

Check out [DEPLOY.md](DEPLOY.md) for instructions to deploy using Capistrano onto Apache/Passenger/MySQL.

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

## TODO

1. Use Ruby 2.4+
1. Use yarn/webpack for Javascript assets ([not until webpack supports Rails engines](https://github.com/rails/webpacker/issues/348))
1. Make site accessible to screen readers (like ChromeVox) by default
1. /wiki/Home actually goes to /
1. Allow images to have descriptions, which are used for screen readers
1. Allow images to be linked as Image:N rather than full paths
1. Allow files, images to be renamed (change title)
1. Allow site to be hosted from /root with lowercase titles/slugs, rather than /wiki/ (will require config on both engine & app)
1. How to set favicons, meta information etc
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
1. Clicking "sign in" at the bottom of the page redirects to the page you were on

## Sites using Railswiki

* http://outerspaces.org.nz ([source](https://github.com/soundasleep/outerspaces))

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
