import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prompt"]

  connect() {
    // Check if running on iOS
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream

    // Check if already installed (standalone mode)
    const isStandalone = window.matchMedia('(display-mode: standalone)').matches || 
                        window.navigator.standalone || 
                        document.referrer.includes('android-app://')

    // Show prompt for iOS users who haven't installed
    if (isIOS && !isStandalone) {
      // Check if user has dismissed the prompt before
      if (!localStorage.getItem('pwa-install-dismissed')) {
        setTimeout(() => {
          this.promptTarget.classList.remove('hidden')
        }, 2000) // Show after 2 seconds
      }
    }
  }

  dismiss() {
    this.promptTarget.classList.add('hidden')
    localStorage.setItem('pwa-install-dismissed', 'true')
  }

  showInstructions() {
    alert('To install Sum:\n\n1. Tap the Share button (square with arrow)\n2. Scroll down and tap "Add to Home Screen"\n3. Tap "Add" to install')
    this.dismiss()
  }
}
