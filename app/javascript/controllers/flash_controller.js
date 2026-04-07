import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message", "container"]
  
  connect() {
    this.timeouts = []
    this.messageTargets.forEach(message => {
      const timeout = setTimeout(() => this.dismissMessage(message), 5000)
      this.timeouts.push(timeout)
    })
  }
  
  dismiss(event) {
    const message = event.currentTarget.closest('[data-flash-target="message"]')
    this.dismissMessage(message)
  }
  
  dismissMessage(message) {
    message.classList.add('opacity-0', 'translate-x-full')
    setTimeout(() => message.remove(), 500)
  }
  
  disconnect() {
    this.timeouts.forEach(timeout => clearTimeout(timeout))
  }
}