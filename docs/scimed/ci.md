# CI

Note: this pertains only to developers at SciMed regarding our internal
CI process.

To fetch screenshots of feature specs that fail on CI, complete this one-time setup:

* Install the `aws` command line client
* Log in to AWS via the `aws` command line client:
  * the "alias" to use is `scimed`.
  * ask Adam for your AWS username and password if you do not already have an account.
  * ask Adam to give you the following permission: `iam:CreateAccessKey`
  * Follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration) to configure your AWS client.

Then, to fetch the screenshots, run the following from the root directory of this project:

`aws s3 cp --recursive s3://com-scimed-gitlab-ci-screenshots/howes_grocery_researcher_portal/ ./ci_failures/`
