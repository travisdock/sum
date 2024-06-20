import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-row"
export default class extends Controller {
  connect() {
    document.querySelectorAll(".clickable-row").forEach(function(row) {
        row.addEventListener("click", function() {
            window.location = row.getAttribute("data-href");
        });
    });
  }
}
