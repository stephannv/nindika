// Entry point for the build script in your package.json
import Rails from "@rails/ujs"
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"

Rails.start()
