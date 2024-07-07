import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.updateMenu()
    window.addEventListener('resize', this.windowResized.bind(this))
  }

  disconnect() {
    window.removeEventListener('resize', this.windowResized.bind(this))
  }

  toggle() {
    this.menuTarget.classList.toggle("open")
  }

  updateMenu() {
    if (window.innerWidth <= 768) {
      this.menuTarget.classList.add("collapsed")
    } else {
      this.menuTarget.classList.remove("collapsed")
    }
  }

  windowResized() {
    this.updateMenu()
  }

}
