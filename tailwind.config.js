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
          "primary-focus": "#ff7aa8",
          "primary-content": "#030303",
          "secondary": "#ff745a",
          "secondary-focus": "#ff8f7a",
          "secondary-content": "#030303",
          "accent": "#5affc6",
          "accent-content": "#030303",
          "neutral": "#383E47",
          "neutral-content": "#f7f8f8",
          "base-100": "#1C2127",
          "base-200": "#22272E",
          "base-content": "#f7f8f8"
        }
      }
    ]
  }
}
