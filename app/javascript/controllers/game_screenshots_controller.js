import { Controller } from 'stimulus'

import Splide from '@splidejs/splide'

export default class extends Controller {
  connect () {
    new Splide(this.element, {
      lazyLoad: 'nearby',
      autoplay: true,
      pauseOnFocus: true,
      interval: 2500
    }).mount()
  }
}
