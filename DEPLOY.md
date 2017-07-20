Deploying a Railswiki parent site
=================================

You can use whatever combination of technologies you'd like to deploy the final application,
for example:

* [Apache, Passenger and MySQL on Ubuntu](http://www.redmine.org/projects/redmine/wiki/HowTo_Install_Redmine_on_Ubuntu_step_by_step)
* [Nginx and Passenger on Ubuntu with Capistrano](https://gorails.com/deploy/ubuntu/16.04)

For example, using Capistrano to deploy a parent `mywiki` site to Apache with Passenger:

1. Add Capistrano to your parent `Gemfile`, and `bundle`:
```ruby
group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-yarn'

  # Add this if you're using rbenv
  # gem 'capistrano-rbenv'

  # Add this if you're using rvm
  # gem 'capistrano-rvm'
end
```

2. Once these are added, generate your capistrano configuration:
```
$ cap install STAGES=production
```

3. Edit your `Capfile` to include bundler, rails, and rbenv/rvm (if necessary):

```ruby
require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/bundler'
require 'capistrano/yarn'

# If you are using rbenv add these lines:
# require 'capistrano/rbenv'
# set :rbenv_type, :user
# set :rbenv_ruby, '2.4.0'

# If you are using rvm add these lines:
# require 'capistrano/rvm'
# set :rvm_type, :user
# set :rvm_ruby_version, '2.4.0'

# Load variables from .env
require 'dotenv'
Dotenv.load

# Copy over railswiki migrations as part of migration
before 'deploy:migrate', :copy_engine_migrations do
  on roles(:app) do
    within current_path do
      execute :rake, 'railties:install:migrations'
    end
  end
end
```

4. We can configure `config/deploy.rb` to setup our app:

```ruby
set :application, "mywiki"
set :repo_url, "git@example.com:me/my_repo.git"

set :deploy_to, '/home/deploy/mywiki'

append :linked_files, "config/database.yml", "config/secrets.yml", ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/uploads", "vendor/bundle", "public/system", "public/uploads"
```

5. Configure `config/deploy/production.rb` and set your remote host IP:

```ruby
Dotenv.load
raise "You need to specify an IP to deploy to in .env" unless ENV["DEPLOY_IP"]
server "#{ENV["DEPLOY_IP"]}", user: 'deploy', roles: %w{app db web}, port: "#{ENV["DEPLOY_PORT"] || 22}".to_i
```

6. Add more lines to your private `.env`:

```yaml
DEPLOY_IP: 123.45.67.89
DEPLOY_PORT: 22
```

7. Make sure that your remote server has the `deploy` user created, and you can [login with SSH public keys](https://www.linode.com/docs/security/use-public-key-authentication-with-ssh). For example:

```bash
$ adduser deploy
$ vim /home/deploy/.ssh/authorized_keys      # copy your local id_rsa.pub into here
```

8. If necessary, [install rbenv and ruby-build](https://github.com/rbenv/rbenv#installation) as your `deploy` user.

```bash
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
$ rbenv install 2.4.0            # or whatever you set in your `Capfile`
```

9. You can now finally deploy using `cap production deploy`. This will fail because you haven't yet configured your deployed application. Create a new database and new database user on your server:

```sql
mysql> create user 'mywiki'@'localhost' identified by '<password>';
Query OK, 0 rows affected (0.00 sec)

mysql> create database mywiki;
Query OK, 1 row affected (0.00 sec)

mysql> grant all privileges on mywiki.* to 'mywiki'@'localhost';
Query OK, 0 rows affected (0.00 sec)
```

10. Set up your `/home/deploy/<APPNAME>/shared/config/database.yml`:

```yaml
production:
  adapter: mysql2
  encoding: utf8
  collation: utf8_unicode_ci
  database: mywiki
  username: mywiki
  password: <password>
  host: localhost
  pool: 5
```

11. Using `rake secret` locally, generate a new `secret_key_base` and create `/home/deploy/<APPNAME>/shared/config/secrets.yml`:

```yaml
production:
  secret_key_base: ...
```

12. Log into [your Google Developers Console](http://www.jevon.org/wiki/Google_OAuth2_with_Ruby_on_Rails) and set up the **Contacts** and **Google+** APIs, using `http://mywiki.com/auth/google_login/callback` as your callback URL.

13. Set up your `/home/deploy/<APPNAME>/shared/.env` with these secrets.

```yaml
OAUTH_CLIENT_ID: ...
OAUTH_CLIENT_SECRET: ...
```

14. For Webpacker assets, you'll need to [install NodeJS v6+](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions) and [Yarn 0.20+](https://yarnpkg.com/lang/en/docs/install/#linux-tab):

```bash
# NodeJS
$ curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
$ sudo apt-get install nodejs

# Yarn
$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt-get update && sudo apt-get install yarn
```

15. You should now be able to deploy the site using capistrano.

```bash
$ cap production deploy
```

16. However, it's still not available to the web through Apache. Set up a new site for Apache in `/etc/apache2/sites-enabled/mywiki.conf`:

```apache
<VirtualHost *:80>
  ServerName mywiki.com
  ServerAlias www.mywiki.com
  DocumentRoot /var/www/mywiki.com/

  # Login as deploy, `cd` to `/home/deploy/mywiki/current` and use `passenger-config about ruby-command` for this path
  PassengerRuby /home/deploy/.rbenv/versions/2.2.3/bin/ruby

  # PassengerLogLevel 3         # change to '4' for more logging
  # PassengerUser root          # if you installed Passenger through apt-get as root

  <Directory /var/www/mywiki.com/>
    AllowOverride all
    RailsBaseURI /mywiki
    PassengerResolveSymlinksInDocumentRoot on
  </Directory>
</VirtualHost>
```

17. Link the deployed `public` folder to `/var/www`, making it clearer what Apache is serving:

```bash
$ sudo ln -s /home/deploy/mywiki/current/public /var/www/mywiki
```

18. Enable the site and reload Apache.

```bash
$ sudo a2ensite mywiki
$ sudo service apache2 reload
```

19. If everything has gone well, you should now be able to visit your new site!

To redeploy, you can just use `cap production deploy` again.

# Troubleshooting

## `rbenv: passenger: command not found`

If Capistrano is failing to run `exec passenger -v`, it may be because you've installed passenger globally,
and not through rbenv (e.g. if you've [already installed Redmine](http://www.redmine.org/projects/redmine/wiki/HowTo_Install_Redmine_on_Ubuntu_step_by_step)).

One solution is to give your `deploy` user `sudo` access and [configure `passenger_restart_with_sudo`](https://github.com/capistrano/passenger/issues/9#issuecomment-92429131).

Another solution is to replace `require 'capistrano/passenger'` to `require 'capistrano/passenger/no_hook'` in your `Capfile`, and then manually restart passenger after deploys.

Finally, an easier solution is to use the deprecated method of restarting Passenger, by setting in your `config/deploy.rb`:

```ruby
set :passenger_restart_with_touch, true
```

This solution avoids running `passenger -v` and instead just touches `tmp/restart.txt`.

For more information see https://github.com/capistrano/passenger/issues/10.

## Passenger cannot write to the log files

If you're running Passenger as a different user, you can make the logs writable by all users through:

```ruby
after 'deploy:symlink:shared', :allow_logs_to_be_writable_by_all do
  on roles(:app) do
    within release_path do
      execute :chmod, "a+rw -R #{current_path}/log"
    end
  end
end
```

Note that this might be a security vunerability, depending on the configuration of your server.

## Carrierwave can't write temporary files to `/tmp/uploads`

If you are running your web server as a different user to your deploy user, you might need to make
your temporary folder writable to all:

```ruby
after 'deploy:cleanup', :allow_tmp_to_be_writable_by_all do
  on roles(:app) do
    execute :chmod, "a+rw #{release_path}/tmp #{release_path}/tmp/uploads"
  end
end
```

## Carrierwave can't write uploads to `public/uploads`

If you are running your web server as a different user to your deploy user, you might need to make
your uploads folder writable to all:

```ruby
after 'deploy:cleanup', :allow_uploads_to_be_writable_by_all do
  on roles(:app) do
    execute :chmod, "a+rw -R #{shared_path}/public/uploads"
  end
end
```

## Further troubleshooting

Check `/var/log/apache2/error.log` for Passenger startup errors.

Check `/home/deploy/mywiki/current/log/` for runtime errors.
