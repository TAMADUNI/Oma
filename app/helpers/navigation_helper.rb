# app/helpers/navigation_helper.rb
module NavigationHelper
  def nav_link_class(path)
    current_page?(path) ? active_nav_class : inactive_nav_class
  end
  
  def active_nav_class
    "bg-gray-900 text-white px-3 py-2 rounded-md text-sm font-medium"
  end
  
  def inactive_nav_class
    "text-gray-300 hover:bg-gray-700 hover:text-white px-3 py-2 rounded-md text-sm font-medium"
  end
  
  def user_avatar_initials(user)
    return "" unless user
      user.email[0].upcase
  end
  
  def navigation_items
    items = []
    
    if user_signed_in?
      # Authenticated navigation items
      items << { name: "Dashboard", path: dashboard_path, icon: "dashboard", authenticated: true }
      items << { name: "Analytics", path: analytics_path, icon: "chart", authenticated: true }
      items << { name: "Reports", path: reports_path, icon: "document", authenticated: true }
      
      # Admin items
      if current_user.admin?
        items << { name: "Admin Panel", path: admin_dashboard_path, icon: "shield", admin: true }
        items << { name: "User Management", path: admin_users_path, icon: "users", admin: true }
      end
      
      # Super admin items
      if current_user.super_admin?
        items << { name: "System Settings", path: super_admin_settings_path, icon: "cog", super_admin: true }
        items << { name: "Audit Logs", path: admin_audit_logs_path, icon: "clipboard", super_admin: true }
      end
      
      # Sign out
      items << { name: "Sign Out", path: destroy_user_session_path, method: :delete, authenticated: true }
    else
      # Public navigation items
      items << { name: "Home", path: root_path, public: true }
      items << { name: "About", path: about_path, public: true }
      items << { name: "Products", path: products_path, public: true }
      items << { name: "Solutions", path: solutions_path, public: true }
      items << { name: "Resources", path: resources_path, public: true }
      items << { name: "Contact", path: contact_path, public: true }
    end
    
    items
  end
  
  def flash_class(level)
    case level.to_sym
    when :notice then "bg-green-50 border-l-4 border-green-400"
    when :success then "bg-green-50 border-l-4 border-green-400"
    when :error then "bg-red-50 border-l-4 border-red-400"
    when :alert then "bg-yellow-50 border-l-4 border-yellow-400"
    else "bg-blue-50 border-l-4 border-blue-400"
    end
  end
  
  def flash_icon(level)
    case level.to_sym
    when :notice, :success
      '<svg class="h-5 w-5 text-green-400" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
      </svg>'.html_safe
    when :error
      '<svg class="h-5 w-5 text-red-400" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
      </svg>'.html_safe
    else
      '<svg class="h-5 w-5 text-blue-400" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
      </svg>'.html_safe
    end
  end
end