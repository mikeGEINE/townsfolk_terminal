# Base image
FROM ruby:3.1.4-alpine

# Set up the working directory
WORKDIR /app

# Install system dependencies
RUN apk update && \
    apk add --no-cache build-base nodejs postgresql-dev tzdata \
    postgresql-client openssh git make \
    nodejs-current imagemagick npm cmake less graphviz \
    chromium chromium-chromedriver ttf-opensans yarn

RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Install Rails dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4 --retry 3

# Copy the application code
COPY . .

# Install the Sass package globally
# RUN yarn global add sass

# Precompile assets with esbuild and Sass
# RUN bundle exec rake assets:precompile

# Start the Rails server
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

RUN mkdir /home/webdrivers && ln -s /usr/bin/chromedriver /home/webdrivers/chromedriver
