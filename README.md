# nindika
[![Releases](https://img.shields.io/github/v/release/stephannv/nindika)](https://github.com/stephannv/nindika/releases)
[![CI](https://github.com/stephannv/nindika/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/stephannv/nindika/actions/workflows/ci.yml?query=branch%3Amain++)
[![License](https://img.shields.io/github/license/stephannv/nindika)](https://github.com/stephannv/nindika/blob/main/LICENSE.txt)

[nindika](https://nindika.com) is a web application focused on Brazilian market that helps users to discover their next Nintendo Switch game.

## Development
### System dependencies
**Ruby:** 3.1.2

**PostgreSQL:** 14

**Node.js:** >15

**Yarn:** >1

## Getting Started
1. Clone project

        $ git@github.com:stephannv/nindika.git

2. Change directory to `nindika`

        $ cd nindika

3. Setup project (Install Ruby and JS dependencies, recreate databases and etc.):

        $ bin/setup


4. Generate new credentials with Nintendo API info:

        $ rm config/credentials.yml.enc
        $ rails credentials:edit

    Fill app id and api key:
      ```
      nintendo_algolia_application_id: 'XXXXX'
      nintendo_algolia_api_key: 'XXXXXX
      ```


5. Import data

        $ bundle exec rake admin:import_data


6. Run project

        $ bin/dev

7. Visit [http://localhost:3000](http://localhost:3000)

## Run tests

    $ bundle exec rspec

## Run linter

    $ bundle exec rubocop

## Run vulnerability scanner

    $ gem install brakeman
    $ brakeman -A -z -q

## License

nindika is licensed under the [MIT](https://github.com/stephannv/nindika/blob/main/LICENSE.txt) license.

## Copyright
Copyright 2021, nindika.
