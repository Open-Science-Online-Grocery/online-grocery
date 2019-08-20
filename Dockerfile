######## Overview
# This makes an image to run the Rails application and tests.
# It includes:
# Ruby, Node, Yarn, etc.

######## How to use
# Instructions are here: https://gitlab.com/scimedsolutions/howesgrocery/howes_grocery_researcher_portal/container_registry

# docker login registry.gitlab.com
# docker build -t registry.gitlab.com/scimedsolutions/howesgrocery/howes_grocery_researcher_portal:0.0.11 .
# docker push registry.gitlab.com/scimedsolutions/howesgrocery/howes_grocery_researcher_portal:0.0.11

# If you would like to make a different version of this image when you're working on new features
# You could build an image with a name that includes your branch name in it. e.g.
# registry.gitlab.com/adam.stasio/basf_midas/my-branch-name or
# registry.gitlab.com/adam.stasio/basf_midas/my-branch-name:tag

FROM ruby:2.6.3
MAINTAINER adam.stasio@scimedsolutions.com

## Install apt based dependencies required to run Rails as
## well as RubyGems. As the Ruby image itself is based on a
## Debian image, we use apt-get to install those.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && \
    apt-get install -y --force-yes \
    build-essential \
    nodejs \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y \
    libc6-i386 \
    && rm -rf /var/lib/apt/lists/*

# Chrome / Chromedriver dependencies
  # RUN apt-get update && \
  #     apt-get install -yq \
  #       libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
  #       libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
  #       libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
  #       libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
  #       libnss3 \
  #       libxcomposite1 ca-certificates fonts-liberation libappindicator1 lsb-release xdg-utils \
  #       && rm -rf /var/lib/apt/lists/*

# Install Chromium
# It seems that the zip folder has an executable and also other files that are needed
# There is probably a way to get them into all the correct directories on the server
# And then `chrome` would just be in the PATH and work.
# I haven't figured that out yet, so for now I'm moving the whole folder into /usr/local/bin/chrome-linux
# and then adding the whole folder to the PATH
# We are now using a fixed version of Chromium by keeping a snapshot on S3. If you want the latest version
# You can get it here: https://download-chromium.appspot.com/dl/Linux_x64?type=snapshots
  # RUN wget -O /tmp/chrome-linux.zip https://s3.amazonaws.com/com-scimed-public/chrome/chromium_linux64_v71.0.3558.0.zip && \
  #     unzip /tmp/chrome-linux.zip -d /usr/local/bin/ && \
  #     chown root:root /usr/local/bin/chrome-linux/chrome && \
  #     chmod 4755 /usr/local/bin/chrome-linux/chrome && \
  #     export PATH=$PATH:/usr/local/bin/chrome-linux

# Install Chromedriver
# We are now using a fixed version of chromedriver by keeping a snapshot on S3. If you want the latest version
# you can get it here:
# RUN LATEST_CHROMEDRIVER=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
#     wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$LATEST_CHROMEDRIVER/chromedriver_linux64.zip
  # RUN wget -O /tmp/chromedriver.zip https://s3.amazonaws.com/com-scimed-public/chrome/chromedriver_linux64_v2.42.zip && \
  #     unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# MySQL client
RUN apt-get update && \
    apt-get install -y --force-yes default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn
RUN gem install bundler

## Avoid "Host key verification failed." when bundling
# RUN mkdir -p ~/.ssh/ && \
#   ssh-keyscan -t rsa git.scimedsolutions.com > ~/.ssh/known_hosts

## Configure the main working directory. This is the base
## directory used in any further RUN, COPY, and ENTRYPOINT
## commands.
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install

RUN echo 'test'

## Expose port 3000 to the Docker host, so we can access it
## from the outside.
EXPOSE 3000

## If you want an image that runs things automatically when it is started you can add a command like this:
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# CMD ["bundle", "exec", "./bin/webpack-dev-server"]
