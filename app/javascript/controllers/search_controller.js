import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  perform(event) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}

