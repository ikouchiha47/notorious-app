# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

### Running with ECR

**Get your aws account id**

```shell
AWS_ACCOUNT=$(./scripts/docker.build.sh get:aws:id)
```

incase of a different `AWS_PROFILE` and `AWS_REGION`, pass them as `env` variables.

```shell
AWS_ACCOUNT=$(AWS_PROFILE=default AWS_REGION=us-west-2 ./scripts/docker.build.sh get:aws:id)
```

**Build and Push the image**

```shell
RAILS_MASTER_KEY=<master-key> AWS_ACCOUNT=$AWS_ACCOUNT ./scripts/docker.build.sh
```



* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
