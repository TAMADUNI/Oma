// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
  }
  
  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle('hidden')
    
    if (!this.menuTarget.classList.contains('hidden')) {
      document.addEventListener('click', this.handleClickOutside)
    } else {
      document.removeEventListener('click', this.handleClickOutside)
    }
  }
  
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
      document.removeEventListener('click', this.handleClickOutside)
    }
  }
  
  disconnect() {
    document.removeEventListener('click', this.handleClickOutside)
  }
}