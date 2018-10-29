# Howe's Grocery Researcher Portal

This application gives researchers the ability to control the behavior of a
simulated online grocery store used to run experiments.


## Initial setup

* Copy `config/database.yml.example` to `config/database.yml` and fill in the
  needed mysql password (if the `root` database user needs a password).
* Set the local ruby version to the one defined in `.ruby-version`
* `bundle install`
* `yarn install`


## Starting your local development server

### Start the webpack dev server

Run `./bin/webpack-dev-server` from the root directory of the application.

### Start the server

In the usual fashion (e.g., `rails s`)

### (Alternative) Using Foreman

As an alternative to the above three steps you can use
[Foreman](http://ddollar.github.io/foreman/).

```
gem install foreman
foreman start
```

Note: do not add the foreman gem to the Gemfile, it will not work.

Unfortunately, while this method has more convenient startup, we have not yet
identified a reliable way to use `pry`. Debugging via RubyMine seems to work
fine, however.

You can control the rails server's port and other details in the `Procfile`.




