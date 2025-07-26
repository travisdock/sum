// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// chartkick
//import "chartkick"
//import "Chart.bundle"

// Register service worker
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js')
      .then(registration => console.log('ServiceWorker registered:', registration))
      .catch(error => console.log('ServiceWorker registration failed:', error));
  });
}
