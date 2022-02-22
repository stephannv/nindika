import { Controller } from '@hotwired/stimulus'

import halfmoon from 'halfmoon'

// Connects to data-controller="toggle-dark-mode"
export default class extends Controller {
  toggle () {
    halfmoon.toggleDarkMode()
  }
}
