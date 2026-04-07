import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "confirmation", "strength"]
  
  validate() {
    const password = this.passwordTarget.value
    const confirmation = this.confirmationTarget?.value
    
    // Password strength validation
    let strength = 0
    if (password.length >= 8) strength++
    if (password.match(/[a-z]/)) strength++
    if (password.match(/[A-Z]/)) strength++
    if (password.match(/[0-9]/)) strength++
    if (password.match(/[^a-zA-Z0-9]/)) strength++
    
    this.updateStrengthIndicator(strength)
    
    // Password match validation
    if (this.confirmationTarget && confirmation) {
      if (password === confirmation) {
        this.confirmationTarget.classList.remove('border-red-500')
        this.confirmationTarget.classList.add('border-green-500')
      } else {
        this.confirmationTarget.classList.remove('border-green-500')
        this.confirmationTarget.classList.add('border-red-500')
      }
    }
  }
  
  updateStrengthIndicator(strength) {
    const colors = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-blue-500', 'bg-green-500']
    const texts = ['Very Weak', 'Weak', 'Medium', 'Strong', 'Very Strong']
    
    this.strengthTargets.forEach((indicator, index) => {
      if (index < strength) {
        indicator.classList.add(colors[strength - 1])
        indicator.classList.remove('bg-gray-200')
      } else {
        indicator.classList.remove(...colors)
        indicator.classList.add('bg-gray-200')
      }
    })
    
    // Update strength text
    const strengthText = document.getElementById('password-strength-text')
    if (strengthText) {
      strengthText.textContent = texts[strength - 1] || ''
      strengthText.className = `text-xs mt-1 ${strength >= 4 ? 'text-green-600' : strength >= 3 ? 'text-blue-600' : 'text-red-600'}`
    }
  }
}