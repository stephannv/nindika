// Entry point for the build script in your package.json
import Rails from "@rails/ujs"
import { Turbo } from "@hotwired/turbo-rails"
import UIkit from "uikit"
import "controllers"

Rails.start()
window.UIkit = UIkit
