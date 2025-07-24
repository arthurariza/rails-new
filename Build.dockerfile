# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.1
ARG BUN_VERSION=1.2.18
FROM oven/bun:$BUN_VERSION AS bun-source
FROM ruby:$RUBY_VERSION-slim-bookworm

# Common dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git

COPY --from=bun-source /usr/local/bin/bun /usr/local/bin/

WORKDIR /app

# Rails
RUN gem install rails

# Create a directory for the app code
COPY . /app

CMD ["/bin/bash"]
