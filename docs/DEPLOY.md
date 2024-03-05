## Servers and Credentials

**NOTE**: These details pertain to the primary OSOG application. If you are using this codebase to run your own application, this information will not apply.

At present, we have a staging server and a production server. These are hosted
under Holly Howe's AWS account.

For SciMed developers, credentials can be accessed at Credential #1062. For other contributors, contact Holly Howe.

### Staging

* [Application](https://howes-grocery.scimed-test.com/)
* Credentials: (SciMed developers, see Credential #899; other developers, please contact Holly)
* SSH: `ssh deployer@howes-grocery.scimed-test.com`
* Rails environment: `staging`

### Production

* [Application](https://openscience-onlinegrocery.com/)
* Credentials: (SciMed developers, see Credential #925; other developers, please contact Holly)
* SSH: `ssh deployer@openscience-onlinegrocery.com`
* Rails environment: `production`

## Deploying

**Important**: For SciMed developers, ensure the latest code is pushed to the
public GitHub repository upon each production deploy.  See details [here](docs/scimed/github.md).

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
