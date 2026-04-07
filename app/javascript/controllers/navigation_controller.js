// app/javascript/controllers/navigation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu"]
  
  toggleMenu(event) {
    const button = event.currentTarget
    const isExpanded = button.getAttribute('aria-expanded') === 'true'
    
    button.setAttribute('aria-expanded', !isExpanded)
    this.mobileMenuTarget.classList.toggle('hidden')
    
    // Animate menu
    if (!this.mobileMenuTarget.classList.contains('hidden')) {
      this.mobileMenuTarget.classList.add('animate-slide-down')
    } else {
      this.mobileMenuTarget.classList.remove('animate-slide-down')
      this.mobileMenuTarget.classList.add('animate-slide-up')
      setTimeout(() => {
        this.mobileMenuTarget.classList.remove('animate-slide-up')
      }, 300)
    }
    
    // Toggle menu button icons
    const openIcon = button.querySelector('svg:first-child')
    const closeIcon = button.querySelector('svg:last-child')
    
    openIcon.classList.toggle('hidden')
    closeIcon.classList.toggle('hidden')
  }
  
  closeMenu() {
    this.mobileMenuTarget.classList.add('hidden')
    const button = document.querySelector('[data-action="click->navigation#toggleMenu"]')
    if (button) {
      button.setAttribute('aria-expanded', 'false')
      const openIcon = button.querySelector('svg:first-child')
      const closeIcon = button.querySelector('svg:last-child')
      openIcon.classList.remove('hidden')
      closeIcon.classList.add('hidden')
    }
  }
}