# Howe's Grocery Researcher Portal

This application gives researchers the ability to control the behavior of a
simulated online grocery store used to run experiments.


## Background

The client originally hired CS students to build a React app that is a simulated
online grocery store. The Researcher Portal is a companion Rails app to allow
researchers to customize the behavior of the React app.

This means that several database tables in this application existed before this
Rails app and therefore do not conform to Rails naming conventions for database
columns. Within this Rails app, we can use `alias_attribute` within models to
alias the columns to names with the expected Rails conventions (see `Product`
model for an example).

Any changes to the database schema must be coordinated with the
client's student developers, and they should be included on any merge requests
that affect the pre-existing database tables or the grocery store React app.

The pre-existing database tables are:

* `categories`
* `subcategories`
* `products`
* `users`


## Initial setup

* Copy `config/database.yml.example` to `config/database.yml` and fill in the
  needed mysql password (if the `root` database user needs a password).
* Set the local ruby version to the one defined in `.ruby-version`
* `bundle install`
* `yarn install`

## Database setup

* `bundle exec rake db:create`
* `bundle exec rake db:migrate`
* `bundle exec rake db:seed`

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


## Logging in

You can log in with email: `admin@admin.com`, password: `adminadmin!1`
