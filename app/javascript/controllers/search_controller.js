import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  perform(event) {
    console.log("performing search")
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }
}

