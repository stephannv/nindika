import { Controller } from "@hotwired/stimulus"

import Cleave from "cleave.js"

// Connects to data-controller="money-input"
export default class extends Controller {
  connect () {
    new Cleave(this.element, {
      numeral: true,
      numeralIntegerScale: 3,
      numeralDecimalScale: 0
    })
  }
}
