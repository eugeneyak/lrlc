FROM ruby:3.4.1-alpine AS builder

RUN apk -U upgrade && apk add --no-cache \
   build-base libpq-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --no-document && bundle install

COPY . ./

CMD ["bundle", "exec", "ruby", "--yjit", "main.rb"]
