module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/pages/**/*.rb',
    './app/pages/**/*.html.erb',
    './app/components/**/*.rb',
    './app/components/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")]
}
