import { Controller } from 'stimulus'

import useCSRFToken from '@/app/use_csrf_token'
import axios from 'axios'

export default class extends Controller {
  static targets = ['checkbox']
  static values = { path: String }

  change() {
    const method = this.checkboxTarget.checked ? 'post' : 'delete'
    const url = this.pathValue
    const headers = { 'X-CSRF-Token': useCSRFToken()  }

    axios({ method, url, headers })
      .catch((_e) => { this.checkboxTarget.checked = !this.checkboxTarget.checked })
  }
}
