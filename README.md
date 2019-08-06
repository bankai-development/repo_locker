# RepoLocker

## Description

Web application written in Elixir that listens for the creation of a repository for an organization and protects the master branch.

## Variables

- GITHUB_TOKEN (required in prod environment)
  - You need this for RepoLocker to access your Github account. I recommend creating a new token.

- REPO_LOCKER_USER (required in prod environment)
  - Basic Auth Username

- REPO_LOCKER_PASS (required in prod environment)
  - Basic Auth Password

- MIX_ENV - Application Environment
  - default dev - options: [dev, prod, test])

- PORT - Port you want application to run on
  - default 4000

## Getting Started

To get this application up and running set the environment variables above and you have multiple options.

Make sure you create a personal access token you can locate it by logging into Gihub and going to [Settings -> Developer settings -> Personal access tokens](https://github.com/settings/tokens). From here you can generate a token for your instance of the RepoLocker application.

You just want to give this user repo access.

### 1. Get Running Quickly for Development

```elixir
mix deps.get
mix run --no-halt
```

### 2. Compile and Release for Production

```elixir
mix deps.get --only prod
MIX_ENV=prod mix release

# This will output instructions on running the application
# after it creates a bin file which you can run like so:
_build/dev/rel/my_app/bin/my_app start
```

### 3. Docker

```elixir
docker build . -t repo_locker:latest

# Then you can run the application like normal with docker with something such as:
docker run -p 4000:4000 repo_locker bin/repo_locker start
```

## Things to Consider

This application forces SSL redirects in prod. For now you need to sit the application on a platform that handles SSL until native support is added.

## Todo

- Add lower level SSL support using Cowboy 2

- Add HMAC Support

## Credits

Sophie DeBenedetto [Mock Server Strategy](https://medium.com/flatiron-labs/rolling-your-own-mock-server-for-testing-in-elixir-2cdb5ccdd1a0)
