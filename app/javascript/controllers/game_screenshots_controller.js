import { Controller } from '@hotwired/stimulus'

import Splide from '@splidejs/splide'

// Connects to data-controller="game-screenshots"
export default class extends Controller {
  connect() {
    new Splide(this.element, {
      lazyLoad: 'nearby',
      autoplay: true,
      pauseOnFocus: true,
      interval: 2500
    }).mount()
  }
}
