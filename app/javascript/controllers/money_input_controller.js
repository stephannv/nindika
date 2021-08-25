import { Controller } from 'stimulus'

import Cleave from 'cleave.js'

export default class extends Controller {
  connect () {
    new Cleave(this.element, {
      numeral: true,
      numeralIntegerScale: 3,
      numeralDecimalScale: 0
    })
  }
}
