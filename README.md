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

* Ensure MySQL is installed locally and running.
* Copy `config/database.yml.example` to `config/database.yml` and fill in the
  needed mysql password (if the `root` database user needs a password).
* Set the local ruby version to the one defined in `.ruby-version` using a ruby version manager like `rbenv`
* From the root directory of the application, run the following commands:
  * `bundle install`
  * `yarn install`
  * `rake db:setup`

Note: To run an abbreviated (and thus faster) set of seeds (only 1000 products), run seeds like so:
`SHORT_SEED=1 rake db:seed`

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


## Visiting the Researcher Portal

To log in to the Researcher Portal, visit `http://localhost:3000`
You can log in with email: `admin@admin.com`, password: `adminadmin!1`


## Visiting the Grocery Store

To navigate to the Grocery Store, visit `http://localhost:3000/store`. You may
enter any text as your session ID to continue.  No other login is needed.
