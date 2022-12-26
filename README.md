# nindika is shutting down on 15/01/2023
Thanks for all support. If you need help with nindika code, getting in touch in discussions.


# nindika
[![Releases](https://img.shields.io/github/v/release/stephannv/nindika)](https://github.com/stephannv/nindika/releases)
[![CI](https://github.com/stephannv/nindika/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/stephannv/nindika/actions/workflows/ci.yml?query=branch%3Amain++)
[![License](https://img.shields.io/github/license/stephannv/nindika)](https://github.com/stephannv/nindika/blob/main/LICENSE.txt)

[nindika](https://nindika.com) is a web application focused on Brazilian market that helps users to discover their next Nintendo Switch game.

## Development Guide
### Development Dependencies
- Ruby 3.1.2
- Node.js 18.0.0
- Yarn 1.x
- Docker + Compose
- libpq
  - brew:
    ```
      brew install libpq
    ```
  - apt:
    ```
      sudo apt-get upgrade
      sudo apt-get install libpq-dev
### Setup
1. Clone project
```sh
git@github.com:stephannv/nindika.git
```

2. Go to `nindika` folder
```sh
cd nindika
```

3. Setup project (Install Ruby and JS dependencies, recreate databases and etc.):
```sh
bin/setup
```

4. Generate new credentials with Nintendo API info:
```sh
rm config/credentials.yml.enc
bin/rails credentials:edit
```

Then fill app id and app key (you can get this credentials inspecting Nintendo website):

```yaml
nintendo_app_id: 'XXXXX'
nintendo_app_key: 'XXXXXX
```

5. Import data
```sh
bundle exec rake admin:import_data
```

6. Run project
```sh
bin/dev
```

7. Visit [http://localhost:3000](http://localhost:3000)

### Run tests

    $ bundle exec rspec

## Run linters

    $ bin/lint

## Run vulnerability scanner

    $ gem install brakeman
    $ brakeman -A -z -q

## License

nindika is licensed under the [MIT](https://github.com/stephannv/nindika/blob/main/LICENSE.txt) license.

## Copyright
Copyright 2022, nindika.
