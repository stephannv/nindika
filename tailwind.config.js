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
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        dark: {
          ...require("daisyui/src/colors/themes")["[data-theme=dark]"],
          "primary": "#ff5a93",
          "primary-content": "#030303",
          "secondary": "#5a93ff",
          "secondary-content": "#030303",
          "accent": "#5affc6",
          "accent-content": "#030303",
          "base-100": "#121212",
          "base-200": "#222222",
          "base-300": "#2c2c2c",
          "base-content": "#f7f8f8"
        }
      }
    ]
  }
}
