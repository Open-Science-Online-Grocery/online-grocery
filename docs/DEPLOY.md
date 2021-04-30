## Servers and Credentials

At present, we have a staging server and a production server. These are hosted
under Holly Howe's AWS account.

For SciMed Solutions developers, credentials can be accessed
[here](https://credentials.scimedsolutions.com/credentials/1062).

For other contributors, contact Holly Howe.

### Staging

* [Application](https://howes-grocery.scimed-test.com/)
* [Credentials (SciMed only; other developers: please contact Holly)](https://credentials.scimedsolutions.com/servers/229)
* SSH: `ssh deployer@howes-grocery.scimed-test.com`
* Rails environment: `staging`

### Production

* [Application](https://openscience-onlinegrocery.com/)
* [Credentials (SciMed only; other developers: please contact Holly)](https://credentials.scimedsolutions.com/servers/237)
* SSH: `ssh deployer@18.204.34.178`
* Rails environment: `production`

## Deploying

Note: All of the following commands are run from your local machine. No need to
SSH into any server.

1. Make sure you have all the updates for the branch you are deploying and
all changes merged in.

1. Make sure the branch you want to deploy is checked out locally.

1. Update the app version. (This is done by using one of the git commands found
   in the comment of `config/app_version.yml`. Ask your project manager if
   you're unsure of what the new version should be.)

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
