import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  connect() {
    var mode = localStorage.getItem('dark-mode');
    document.documentElement.setAttribute('data-theme', mode);
    if (mode == 'dark') {
      document.getElementById('dark-mode-toggle').textContent = "Sum ☼";
    } else {
      document.getElementById('dark-mode-toggle').textContent = "Sum ☽";
    }
  }

  toggle() {
    if (document.documentElement.dataset.theme == 'dark') {
      document.documentElement.setAttribute('data-theme', 'light');
      document.getElementById('dark-mode-toggle').textContent = "Sum ☽";
      localStorage.setItem('dark-mode', 'light');
    } else {
      document.documentElement.setAttribute('data-theme', 'dark');
      document.getElementById('dark-mode-toggle').textContent = "Sum ☼";
      localStorage.setItem('dark-mode', 'dark');
    }
  }
}
