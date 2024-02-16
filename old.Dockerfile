FROM ruby:3.1.2

ARG RAILS_ROOT=/usr/src/notorious
ARG RAILS_MASTER_KEY
# ARG BUILD_PKGS="build-base curl-dev postgresql-dev yaml-dev zlib-dev git tzdata"

WORKDIR $RAILS_ROOT

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

COPY Gemfile Gemfile.lock /usr/src/notorious/
# RUN apk update && apk add --update --no-cache $BUILD_PKGS 
RUN gem install bundler \
	&& bundle config set --local without 'development test' \
	&& bundle config set path 'vendor/bundle' \
	&& bundle config --global frozen 1 \
	&& bundle install \
	&& rm -rf $GEM_HOME/cache/*

COPY . ${RAILS_ROOT}
RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "puma"]
