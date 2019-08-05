# RepoLocker

## Description

Web application written in Elixir that listens for the creation of a repository for an organization and protects the master branch.

## Variables

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

### 1. Quick and Easy Deploy to Heroku

```elixir
```

### 2. Get Running Quickly

```elixir
mix run --no-halt
```

## Things to Consider

This application forces SSL redirects in prod. For now you need to sit the application on a platform that handles SSL until native support is added.

## Todo

- Add lower level SSL support using Cowboy 2

- Add HMAC Support

## Credits

Sophie DeBenedetto [Mock Server Strategy](https://medium.com/flatiron-labs/rolling-your-own-mock-server-for-testing-in-elixir-2cdb5ccdd1a0)
