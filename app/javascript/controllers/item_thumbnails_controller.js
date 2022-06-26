import { Controller } from "@hotwired/stimulus"

import Splide from "@splidejs/splide"

// Connects to data-controller="item-thumbnails"
export default class extends Controller {
  static targets = ["main", "thumbnail"]

  connect() {
    let main = new Splide(this.mainTarget, {
      type: "fade",
      rewind: true,
      pagination: false,
      arrows: false,
    })

    let thumbnails = new Splide(this.thumbnailTarget, {
      fixedWidth: 128,
      fixedHeight: 72,
      gap: 10,
      rewind: true,
      pagination: false,
      isNavigation: true,
      breakpoints: {
        600: {
          fixedWidth : 128,
          fixedHeight: 72,
        },
      }
    } )

    main.sync( thumbnails )
    main.mount()
    thumbnails.mount()
  }
}
