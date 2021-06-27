const { environment } = require('@rails/webpacker')
const path = require('path')
const webpack = require('webpack')

environment.config.merge({
  resolve: {
    alias: {
      "@": path.resolve(__dirname, '..', '..', 'app', 'javascript')
    }
  }
})

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  axios: 'axios',
  halfmoon: 'halfmoon'
}))


module.exports = environment
