FROM elixir:1.9.1-alpine as build

# install build dependencies
RUN apk add --update git build-base

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile

# build project
COPY lib lib
RUN mix compile

# build release
RUN mix release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --update bash openssl

RUN mkdir -p /app/lib/repo_locker/messages
WORKDIR /app

COPY --from=build /app/_build/prod/rel/repo_locker ./
COPY --from=build /app/lib/repo_locker/messages/* ./lib/repo_locker/messages/
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app