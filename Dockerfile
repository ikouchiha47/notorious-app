# Stage 1: Build dependencies (minimal Alpine)
FROM ruby:3.1.2-alpine AS build-dev

ARG RAILS_ROOT=/usr/src/notorious
ARG RAILS_MASTER_KEY
ARG BUILD_PKGS="build-base curl-dev postgresql-dev yaml-dev zlib-dev git tzdata"

WORKDIR $RAILS_ROOT

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
ENV BUNDLE_PATH=$RAILS_ROOT/vendor/bundle

COPY Gemfile Gemfile.lock $RAILS_ROOT/
RUN apk update && apk add --update --no-cache $BUILD_PKGS

# Install the desired Bundler version explicitly
RUN gem install bundler\
    && bundle config set --local without 'development test' \
    && bundle config set --local path 'vendor/bundle' \
    && bundle config set --global frozen 1 \
    && bundle install \
    && rm -rf $GEM_HOME/cache/* \
    && rm vendor/bundle/ruby/3.1.0/cache/*.gem \
    && find vendor/bundle/ruby/3.1.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/3.1.0/gems/ -name "*.o" -delete

COPY . ${RAILS_ROOT}
RUN bundle exec rake assets:precompile && rm -rf tmp/cache vendor/assets

# Stage 2: Final image (minimal Alpine)
FROM ruby:3.1.2-alpine

ARG RAILS_ROOT=/usr/src/notorious

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
ENV BUNDLE_PATH=$RAILS_ROOT/vendor/bundle

WORKDIR $RAILS_ROOT

COPY --from=build-dev $RAILS_ROOT .
RUN apk update && apk add --update --no-cache tzdata postgresql-client && rm -rf /var/cache/apk/*

RUN bundle config set --local path vendor/bundle \
    && bundle config set --local without 'development test' \
    && mkdir -p tmp/pids/

CMD ["bundle", "exec", "puma"]

