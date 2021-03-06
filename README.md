# Howe's Grocery Researcher Portal

This application gives researchers the ability to control the behavior of a
simulated online grocery store used to run experiments.

## Background

The application originally consisted of a React app (built by students) that is
a simulated online grocery store. The Researcher Portal is a companion Rails app
to allow researchers to customize the behavior of the React app.

## Initial setup

* Ensure MySQL is installed locally and running.
* Copy `config/database.yml.example` to `config/database.yml` and fill in the
  needed mysql password (if the `root` database user needs a password).
* Copy `howes_grocery.priv.example` to `howes_grocery.priv`.
* Get the `config/master.key` file from another developer on the project or (SciMed Solutions developers only) from [this credential](https://credentials.scimedsolutions.com/credentials/972).
* Set the local ruby version to the one defined in `.ruby-version` using a ruby version manager like `rbenv`
* From the root directory of the application, run the following commands:
  * `gem install bundler`
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


## Starting your local development server

### Start the webpack dev server

In one terminal tab, run `./bin/webpack-dev-server` from the root directory of the application.

### Start the server

In another terminal tab, start the Rails server with `rails s`


## Visiting the Researcher Portal

To log in to the Researcher Portal, visit `http://localhost:3000`
You can log in with email: `admin@admin.com`, password: `adminadmin!1`


## Visiting the Grocery Store

To navigate to the Grocery Store, visit `http://localhost:3000/store`. You may
enter any text as your session ID to continue.  No other login is needed.


## Testing

All rspec tests, JS tests, rubocop, and eslint can be run with the default rake
task (`bundle exec rake`)

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

For details about CI (only pertains to developers at SciMed Solutions), see
[docs/scimed/ci.md](docs/scimed/ci.md)


## Servers, Credentials, and Deploying

See [docs/DEPLOY.md](docs/DEPLOY.md)


## Updating categories

To update the categories, subcategories, and subsubcategories in the store on a server:

1. On your local development machine, replace the file at `db/seeds/base/categories.csv` with the updated categories file.
  * The new file must be in the same format as the old file.
  * This file must be a CSV file, not an Excel file.

1. Test the new file locally by running this command in a terminal within from the root directory of the application: `bundle exec rake update_categories`.  If the output ends with `Success!`, the task has succeeded. Otherwise, there is a problem with the file format.

1. Commit the updated file to git and push the change to GitLab.

1. Follow the instructions under "Deploying" (above) to deploy the updated file to the server.

1. SSH to the server (see "Servers and Credentials" above) and navigate to `/var/www/apps/howes_grocery/current`

1. In this directory on the server, run the command appropriate to the server you are on:
	*  For the staging server, run `bundle exec rake update_categories RAILS_ENV=staging`
	*  For the production server, run `bundle exec rake update_categories RAILS_ENV=production`


## Updating products

To update the products in the store on a server:

1. On your local development machine, replace the file at `db/seeds/base/products.csv` with the updated products file.
  * The new file must be in the same format as the old file.
  * This file must be a CSV file, not an Excel file.
  * If you are adding new products to the CSV, you do not need to fill in the "awsImageUrl" column for them - that will be filled in for you.  You *should* fill in the "imageSrc" column, though.
  * If the CSV refers to new categories, be sure to update the categories before updating the products.

1. Test the new file locally by running this command in a terminal within from the root directory of the application: `bundle exec rake update_products`.  If the output ends with `Success!`, the task has succeeded. Otherwise, there is a problem with the file format.

  Note that if you have added new products, the CSV will be updated with the AWS image URL. You should commit these changes.

1. Commit the updated file to git and push the change to GitLab.

1. Follow the instructions under "Deploying" (above) to deploy the updated file to the server.

1. SSH to the server (see "Servers and Credentials" above) and navigate to `/var/www/apps/howes_grocery/current`

1. In this directory on the server, run the command appropriate to the server you are on:
	*  For the staging server, run `bundle exec rake update_products RAILS_ENV=staging`
	*  For the production server, run `bundle exec rake update_products RAILS_ENV=production`
