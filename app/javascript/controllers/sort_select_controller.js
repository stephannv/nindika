import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sort-select"
export default class extends Controller {
  makeRequest () {
    const urlSearchParams = new URLSearchParams(window.location.search);
    const currentParams = Object.fromEntries(urlSearchParams.entries());
    const currentPath = new URL(window.location.pathname, window.location.href).href
    currentParams.sort = this.element.value
    delete currentParams.page
    const queryString = new URLSearchParams(currentParams).toString()
    window.location.href = currentPath.concat("?", queryString)
  }
}
