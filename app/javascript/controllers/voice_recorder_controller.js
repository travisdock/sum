import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status", "indicator", "amountField", "dateField", "notesField", "categorySelect"]
  static values = { url: String }

  connect() {
    this.mediaRecorder = null
    this.audioChunks = []
    this.isRecording = false
  }

  async toggleRecording() {
    if (this.isRecording) {
      this.stopRecording()
    } else {
      await this.startRecording()
    }
  }

  async startRecording() {
    try {
      // Check if browser supports MediaRecorder
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        this.showError('Voice recording is not supported in your browser')
        return
      }

      // Request microphone permission
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })

      // Initialize MediaRecorder
      this.mediaRecorder = new MediaRecorder(stream, { mimeType: 'audio/webm' })
      this.audioChunks = []

      this.mediaRecorder.addEventListener('dataavailable', (event) => {
        this.audioChunks.push(event.data)
      })

      this.mediaRecorder.addEventListener('stop', () => {
        const audioBlob = new Blob(this.audioChunks, { type: 'audio/webm' })
        this.submitAudio(audioBlob)

        // Stop all audio tracks to release microphone
        stream.getTracks().forEach(track => track.stop())
      })

      this.mediaRecorder.start()
      this.isRecording = true
      this.showRecording()
    } catch (error) {
      this.showError('Failed to start recording. Please check your microphone permissions.')
    }
  }

  stopRecording() {
    if (this.mediaRecorder && this.isRecording) {
      this.mediaRecorder.stop()
      this.isRecording = false
      this.showProcessing()
    }
  }

  async submitAudio(blob) {
    try {
      const formData = new FormData()
      formData.append('audio_file', blob, 'recording.webm')

      // Get CSRF token
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

      const response = await fetch(this.urlValue, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': csrfToken
        },
        body: formData
      })

      const result = await response.json()

      if (result.success) {
        this.populateForm(result.data)
        this.clearFeedback()
      } else {
        this.showError(result.error || 'Failed to process audio')
      }
    } catch (error) {
      this.showError('Failed to upload audio. Please try again.')
    } finally {
      this.showIdle()
    }
  }

  populateForm(data) {
    // Populate amount field
    if (data.amount && this.hasAmountFieldTarget) {
      this.amountFieldTarget.value = data.amount
    }

    // Populate date field only if a date was extracted
    // If null, leave the form's default date (today)
    if (data.date && data.date !== null && this.hasDateFieldTarget) {
      this.dateFieldTarget.value = data.date
    }

    // Populate notes field
    if (data.notes && this.hasNotesFieldTarget) {
      this.notesFieldTarget.value = data.notes
    }

    // Populate category select (case-insensitive match)
    if (data.category_name && this.hasCategorySelectTarget) {
      const categorySelect = this.categorySelectTarget
      const options = Array.from(categorySelect.options)

      // Try to find matching category by text (case-insensitive)
      const matchingOption = options.find(option =>
        option.text.toLowerCase() === data.category_name.toLowerCase()
      )

      if (matchingOption) {
        categorySelect.value = matchingOption.value
      }
    }
  }

  showRecording() {
    if (this.hasButtonTarget) {
      this.buttonTarget.innerHTML = '<span data-voice-recorder-target="indicator">🔴</span> <span>Stop Recording</span>'
      this.buttonTarget.disabled = false
    }
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.style.display = 'inline'
    }
  }

  showProcessing() {
    if (this.hasButtonTarget) {
      this.buttonTarget.innerHTML = '<span>Processing...</span>'
      this.buttonTarget.disabled = true
    }
  }

  showIdle() {
    if (this.hasButtonTarget) {
      this.buttonTarget.innerHTML = '<span>Record Voice Entry</span>'
      this.buttonTarget.disabled = false
    }
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.style.display = 'none'
    }
  }

  showError(message) {
    if (this.hasStatusTarget) {
      this.statusTarget.innerHTML = `
        <div style="padding: 1rem; background: #f8d7da; border: 1px solid #f5c6cb; border-radius: 4px; margin-top: 1rem;">
          <p style="margin: 0; color: #721c24; font-size: 0.9rem;">${message}</p>
        </div>
      `
    }
  }

  clearFeedback() {
    if (this.hasStatusTarget) {
      this.statusTarget.innerHTML = ''
    }
  }
}
