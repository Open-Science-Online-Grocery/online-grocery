# Howe's Grocery Researcher Portal

This application gives researchers the ability to control the behavior of a
simulated online grocery store used to run experiments.


## Background

The client originally hired CS students to build a React app that is a simulated
online grocery store. The Researcher Portal is a companion Rails app to allow
researchers to customize the behavior of the React app.

Any changes to the database schema must be coordinated with the
client's student developers, and they should be included on any merge requests
that affect the pre-existing database tables or the grocery store React app.

The pre-existing database tables are:

* `categories`
* `subcategories`
* `products`
* `participant_actions` (formerly `users`)

## Initial setup

* Ensure MySQL is installed locally and running.
* Copy `config/database.yml.example` to `config/database.yml` and fill in the
  needed mysql password (if the `root` database user needs a password).
* Get the `config/master.key` file from another developer on the project.
  (see "Rails credentials" for more information)
* Set the local ruby version to the one defined in `.ruby-version` using a ruby version manager like `rbenv`
* From the root directory of the application, run the following commands:
  * `bundle install`
  * `yarn install`
  * `rake db:setup`

Note: To run an abbreviated (and thus faster) set of seeds (only 1000 products), run seeds like so:
`SHORT_SEED=1 rake db:seed`

### Rails credentials

This application is using Rails Credentials which was first introduced in
Rails 5.2. There is an encrypted file kept in source control called
`config/credentials.yml.enc`. The way this file is decrypted is by running
the command `bin/rails credentials:edit` in your terminal. Note, you must have
the file `config/master.key` for this to work. Sensitive information can be
stored in this file in YAML format.

The following credentials

```yml
foo: bar
```
can be accessed with `Rails.application.credentials.foo`, which will return `bar`.

See `config/storage.yml` for more examples.

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


## Testing

All rspec tests, JS tests, rubocop, and eslint can be run with the default rake
task (`bundle exec rake`)

If feature specs are not running correctly, try updating the chromedriver
version from the command line: `chromedriver-update <version number>`.

Currently all feature tests run in a headless chrome browser. To troubleshoot feature
tests you can view them running in a Chrome browser. To do this add the `BROWSER` environment
variable to your rspec command:

`BROWSER=1 bundle exec rspec spec/feature/feature_spec.rb`


### Testing Troubleshooting

Occasionally webpacker will not recognize javascript changes, especially when
the changes came from a git pull. If this happens many, if not all, of the
javascript enabled tests will fail.
To fix, run `RAILS_ENV=test ./bin/webpack`


## CI

To fetch screenshots of feature specs that fail on CI, complete this one-time setup:

* Install the `aws` command line client
* Log in to AWS via the `aws` command line client:
  * the "alias" to use is `scimed`.
  * ask Adam for your AWS username and password if you do not already have an account.
  * ask Adam to give you the following permission: `iam:CreateAccessKey`
  * Follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration) to configure your AWS client.

Then, to fetch the screenshots, run the following from the root directory of this project:

`aws s3 cp --recursive s3://com-scimed-gitlab-ci-screenshots/howes_grocery_researcher_portal/ ./ci_failures/`


## Servers and Credentials

At present, we have a staging server and a production server.  For any server, if you are unable to ssh in without a password, ask another developer with ssh access to add your public key to the authorized keys file.

### Staging

* [Application](https://howes-grocery.scimed-test.com/)
* [Credentials](https://credentials.scimed.local/servers/229)
* SSH: `ssh deployer@howes-grocery.scimed-test.com`
* Rails environment: `staging`

### Production

* [Application](https://18.204.34.178/)
* [Credentials](https://credentials.scimed.local/servers/230)
* SSH: `ssh deployer@18.204.34.178`
* Rails environment: `production`

## Deploying

Note: All of the following commands are run from your local machine. No need to ssh into any server.

1. Make sure you have all the updates for the branch you are deploying and
all changes merged in.

1. Update the app version. (This is done by using one of the git commands found in the comment of `config/app_version.yml`. Ask your project manager if you're unsure of what the new version should be.)

1. Enable the maintenance page for the application: `bundle exec cap #{environment} maintenance:enable`. If you are deploying to staging environment you would enter
`bundle exec cap staging maintenance:enable`

1. Deploy the application: `bundle exec cap #{environment} deploy`. If you are
deploying to the staging environment you would enter `bundle exec cap staging deploy`

1. Disable the maintenance page for the application: `bundle exec cap #{environment}
maintenance:disable`.

1. Check to be sure the site loads and the app version has been updated by logging
in and hovering over the Howe's Grocery Researcher Portal logo in the upper left corner.
