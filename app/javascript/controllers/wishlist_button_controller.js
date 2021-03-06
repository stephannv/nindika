import { Controller } from 'stimulus'

import useCSRFToken from '@/app/use_csrf_token'

export default class extends Controller {
  static targets = ['button', 'icon']
  static classes = ['activeButton', 'activeIcon', 'inactiveButton', 'inactiveIcon', 'loadingIcon']
  static values = { isActive: Boolean, addPath: String, removePath: String }

  toggle () {
    this.iconTarget.className = this.loadingIconClass
    this.isActiveValue ? this.removeItem() : this.addItem()
  }

  addItem () {
    axios.post(this.addPathValue, {}, { headers: { 'X-CSRF-Token': useCSRFToken() } })
      .then(() => { this.setActive() })
      .catch(error => { this.onError(error) })
  }

  removeItem () {
    axios.delete(this.removePathValue, { headers: { 'X-CSRF-Token': useCSRFToken() } })
      .then(() => { this.setInactive() })
      .catch((error) => { this.onError(error) })
  }

  onError (error) {
    const message = error.response?.data?.message || 'error'
    halfmoon.initStickyAlert({ content: message, alertType: 'alert-danger' })
    this.isActiveValue ? this.setActive() : this.setInactive()
  }

  setActive () {
    this.isActiveValue = true
    this.buttonTarget.className = this.activeButtonClass
    this.iconTarget.className = this.activeIconClass
  }

  setInactive () {
    this.isActiveValue = false
    this.buttonTarget.className = this.inactiveButtonClass
    this.iconTarget.className = this.inactiveIconClass
  }
}
