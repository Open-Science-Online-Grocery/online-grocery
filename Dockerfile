######## Overview
# This makes an image to run the Rails application and tests.
# It includes:
# Ruby, Node, Yarn, etc.

######## How to use
# Instructions are here: https://gitlab.com/scimedsolutions/howesgrocery/howes_grocery_researcher_portal/container_registry

# docker login registry.gitlab.com
# docker build -t registry.gitlab.com/scimedsolutions/howesgrocery/howes_grocery_researcher_portal:0.0.13 .
# docker push registry.gitlab.com/scimedsolutions/howesgrocery/howes_grocery_researcher_portal:0.0.13

# If you would like to make a different version of this image when you're working on new features
# You could build an image with a name that includes your branch name in it. e.g.
# registry.gitlab.com/adam.stasio/basf_midas/my-branch-name or
# registry.gitlab.com/adam.stasio/basf_midas/my-branch-name:tag

FROM ruby:2.6.3

LABEL name="Howe's Grocery CI"
LABEL version="0.0.13"

## Install apt based dependencies required to run Rails as
## well as RubyGems. As the Ruby image itself is based on a
## Debian image, we use apt-get to install those.
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs \
    unzip \
    chromium \
    default-mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN npm install -g yarn
RUN gem install bundler && gem cleanup all

## Configure the main working directory. This is the base
## directory used in any further RUN, COPY, and ENTRYPOINT
## commands.
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app

ENV BUNDLE_PATH="/vendor/ruby"

RUN bundle config set without 'production development' && \
    bundle install
