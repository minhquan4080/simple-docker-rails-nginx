FROM ruby:2.3-alpine

RUN apk add --no-cache \
  alpine-sdk \
  tzdata \
  nodejs \
  mariadb-dev

ENV APP_ROOT /opt/app

WORKDIR $APP_ROOT

COPY Gemfile* $APP_ROOT/
RUN bundle install -j4

ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV:-production}
COPY . $APP_ROOT

# Assets precompile
RUN if [ $RAILS_ENV = "production" ]; then bundle exec rake assets:precompile --trace; fi
# Expose assets for web container
VOLUME $APP_ROOT/public
