ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

RUN gem update --system
RUN gem install bundle

WORKDIR /app
RUN echo 'gem: --no-rdoc --no-ri >> "$HOME/.gemrc"'

COPY Gemfile Gemfile.lock ./

RUN bundle install -j $(nproc)
