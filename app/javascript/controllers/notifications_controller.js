// app/javascript/controllers/notifications_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown"]
  
  connect() {
    this.fetchNotifications()
    this.startPolling()
  }
  
  toggle(event) {
    event.stopPropagation()
    this.dropdownTarget.classList.toggle('hidden')
    
    if (!this.dropdownTarget.classList.contains('hidden')) {
      this.markAsRead()
    }
  }
  
  fetchNotifications() {
    fetch('/notifications.json')
      .then(response => response.json())
      .then(data => {
        this.updateNotificationBadge(data.unread_count)
        this.renderNotifications(data.notifications)
      })
  }
  
  startPolling() {
    setInterval(() => {
      this.fetchNotifications()
    }, 30000) // Poll every 30 seconds
  }
  
  updateNotificationBadge(count) {
    const badge = this.element.querySelector('.notification-badge')
    if (badge) {
      if (count > 0) {
        badge.classList.remove('hidden')
        badge.textContent = count > 9 ? '9+' : count
      } else {
        badge.classList.add('hidden')
      }
    }
  }
  
  renderNotifications(notifications) {
    const container = this.dropdownTarget.querySelector('.notifications-list')
    if (container) {
      if (notifications.length === 0) {
        container.innerHTML = '<div class="p-4 text-center text-gray-500">No new notifications</div>'
      } else {
        container.innerHTML = notifications.map(notification => `
          <a href="${notification.path}" class="block hover:bg-gray-50">
            <div class="px-4 py-3">
              <p class="text-sm font-medium text-gray-900">${notification.title}</p>
              <p class="text-xs text-gray-500">${notification.message}</p>
              <p class="text-xs text-gray-400 mt-1">${notification.time_ago}</p>
            </div>
          </a>
        `).join('')
      }
    }
  }
  
  markAsRead() {
    fetch('/notifications/mark_as_read', { method: 'POST' })
  }
  
  disconnect() {
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval)
    }
  }
}