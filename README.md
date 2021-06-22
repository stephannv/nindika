# nindika
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
