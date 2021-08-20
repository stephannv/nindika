# nindika
[![Releases](https://img.shields.io/github/v/release/stephannv/nindika)](https://github.com/stephannv/nindika/releases)
[![CI](https://github.com/stephannv/nindika/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/stephannv/nindika/actions/workflows/ci.yml?query=branch%3Amain++)
[![License](https://img.shields.io/github/license/stephannv/nindika)](https://github.com/stephannv/nindika/blob/main/LICENSE.txt)

[nindika](https://nindika.com) is a web application focused on Brazilian market that helps users to discover their next Nintendo Switch game.

## Development
### System dependencies
**Ruby:** 3.0.2

**PostgreSQL:** 13

**Node.js:** >15

## Getting Started
1. Clone project

        $ git@github.com:stephannv/nindika.git

2. Change directory to `nindika`

        $ cd nindika

3. Install project dependencies:

        $ bundle install
        $ yarn install

4. Setup database:

        $ rails db:setup


5. Generate new credentials with Nintendo API info:

        $ rm config/credentials.yml.enc
        $ rails credentials:edit

    Fill app id and api key:
      ```
      nintendo_algolia_application_id: 'XXXXX'
      nintendo_algolia_api_key: 'XXXXXX
      ```


6. Import data

        $ rake admin:import_data


7. Run project

        $ rails s -p 3000

8. Visit [http://localhost:3000](http://localhost:3000)

## Run tests

    $ bundle exec rspec spec

## Run linter

    $ bundle exec rubocop

## Run vulnerability scanner

    $ brakeman -A -z -q

## License

nindika is licensed under the [MIT](https://github.com/stephannv/nindika/blob/main/LICENSE.txt) license.

## Copyright
Copyright 2021, nindika.
