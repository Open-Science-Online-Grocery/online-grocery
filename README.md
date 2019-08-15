# Howe's Grocery Researcher Portal

This application gives researchers the ability to control the behavior of a
simulated online grocery store used to run experiments.


## Background

The client originally hired CS students to build a React app that is a simulated
online grocery store. The Researcher Portal is a companion Rails app to allow
researchers to customize the behavior of the React app.


## Initial setup

* Ensure MySQL is installed locally and running.
* Copy `config/database.yml.example` to `config/database.yml` and fill in the
  needed mysql password (if the `root` database user needs a password).
* Copy `howes_grocery.priv.example` to `howes_grocery.priv`.
* Get the `config/master.key` file from another developer on the project or from [this credential](https://credentials.scimedsolutions.com/credentials/972).
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

See `config/storage.yml` for more examples.

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

* [Application](https://openscience-onlinegrocery.com/)
* [Credentials](https://credentials.scimed.local/servers/237)
* SSH: `ssh deployer@18.204.34.178`
* Rails environment: `production`

## Deploying

Note: All of the following commands are run from your local machine. No need to SSH into any server.

1. Make sure you have all the updates for the branch you are deploying and
all changes merged in.

1. Make sure the branch you want to deploy is checked out locally.

1. Update the app version. (This is done by using one of the git commands found in the comment of `config/app_version.yml`. Ask your project manager if you're unsure of what the new version should be.)

1. Enable the maintenance page for the application: 
	* For the staging server, run `bundle exec cap staging maintenance:enable`
	* For the production server, run `bundle exec cap production maintenance:enable`

1. Deploy the application: 
    * For the staging server, run `bundle exec cap staging deploy`
    * For the production server, run `bundle exec cap production deploy`

1. Disable the maintenance page for the application: 
	* For the staging server, run `bundle exec cap staging maintenance:disable`
	* For the production server, run `bundle exec cap production maintenance:disable`

1. Check to be sure the site loads and the app version has been updated by logging
in and hovering over the Howe's Grocery Researcher Portal logo in the upper left corner.


## Updating products

To update the products in the store on a server:

1. On your local development machine, replace the file at `db/seeds/base/products.csv` with the updated products file. The new file must be in the same format as the old file. Note that this file must be a CSV file, not an Excel file.

1. Test the new file locally by running this command in a terminal within from the root directory of the application: `bundle exec rake update_products`.  If the output ends with `Success!`, the task has succeeded. Otherwise, there is a problem with the file format.

1. Commit the updated file to git and push the change to GitLab.

1. Follow the instructions under "Deploying" (above) to deploy the updated file to the server.

1. SSH to the server (see "Servers and Credentials" above) and navigate to `/var/www/apps/howes_grocery/current`

1. In this directory on the server, run the command appropriate to the server you are on:
	*  For the staging server, run `bundle exec rake update_products RAILS_ENV=staging`
	*  For the production server, run `bundle exec rake update_products RAILS_ENV=production`

Note that we have been aiming to keep the "adjusted_products" tab of the [product spreadsheet on Google Drive](https://docs.google.com/spreadsheets/d/1tL9JlFDYz1M-muNOCGf-qaF2PtuTmy_2xf9RQLNeX00/edit?usp=sharing) and `db/seeds/base/products.csv` synchronized.
