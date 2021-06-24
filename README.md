# nindika
[![Releases](https://img.shields.io/github/v/release/stephannv/nindika)](https://github.com/stephannv/nindika/releases) 
[![CI](https://github.com/stephannv/nindika/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/stephannv/nindika/actions/workflows/ci.yml?query=branch%3Amain++)
[![License](https://img.shields.io/github/license/stephannv/nindika)](https://github.com/stephannv/nindika/blob/main/LICENSE.txt) 







[nindika](https://nindika.com) is a web application that helps users to discover their next Nintendo Switch game.

## Development
### System dependencies
**Ruby:** 3.0.1

**PostgreSQL:** 13

**Node.js:** >15

#### Run projects
Clone project
```
git@github.com:stephannv/nindika.git
cd nindika
```

Install project dependencies:
```
bundle install
yarn install
```

Setup database:
```
rails db:setup
```

Import data
```
rake admin:import_data
```

Run project
```
rails s -p 3000
```

Visit [http://localhost:3000](http://localhost:3000)
