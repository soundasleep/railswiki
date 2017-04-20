# Railswiki
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'railswiki'
```

And then execute:
```bash
$ bundle
```

Then enable in your application in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount Railswiki::Engine, at: "/wiki"
end
```

Install and run migrations:

```bash
$ rails railties:install:migrations
$ rails db:migrate
```

You can now host locally and visit http://localhost:3000/wiki:

```bash
$ rails s
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
