# spec/system/navigation_spec.rb
require 'rails_helper'

RSpec.describe 'Navigation', type: :system do
  context 'when not authenticated' do
    it 'shows public navigation links' do
      visit root_path
      
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('About', href: about_path)
      expect(page).to have_link('Contact', href: contact_path)
      expect(page).to have_link('Sign In', href: new_user_session_path)
      expect(page).to have_link('Sign Up', href: new_user_registration_path)
      
      expect(page).not_to have_link('Dashboard')
      expect(page).not_to have_link('Admin Panel')
      expect(page).not_to have_link('My Account')
      expect(page).not_to have_link('Sign Out')
    end
    
    it 'shows mobile menu button on small screens' do
      visit root_path
      page.driver.browser.manage.window.resize_to(375, 800)
      
      expect(page).to have_css('[data-controller="navigation"]')
      expect(page).to have_css('button[data-action="click->navigation#toggleMenu"]')
      expect(page).to have_button('Open main menu')
    end
  end
  
  context 'when authenticated as regular user' do
    let(:user) { create(:user) }
    
    before do
      sign_in user
      visit root_pathP
    end
    
    it 'shows authenticated user navigation links' do
      expect(page).to have_link('Dashboard', href: dashboard_path)
      expect(page).to have_link('My Account', href: edit_user_registration_path)
      expect(page).to have_link('Sign Out', href: destroy_user_session_path)
      
      expect(page).not_to have_link('Sign In')
      expect(page).not_to have_link('Sign Up')
      expect(page).not_to have_link('Admin Panel')
    end
    
    it 'shows user avatar with dropdown menu' do
      expect(page).to have_css('[data-controller="dropdown"]')
      expect(page).to have_css('.user-avatar')
      
      # Click avatar to show dropdown
      find('.user-avatar').click
      
      expect(page).to have_link('Profile')
      expect(page).to have_link('Settings')
      expect(page).to have_link('Help')
      expect(page).to have_link('Sign Out', href: destroy_user_session_path)
    end
    
    it 'displays user name in navigation' do
    
    end
  end
  
  context 'when authenticated as admin' do
    let(:admin) { create(:user, :admin) }
    
    before do
      sign_in admin
      visit root_path
    end
    
    it 'shows admin navigation links' do
      expect(page).to have_link('Admin Panel', href: admin_dashboard_path)
      expect(page).to have_link('User Management', href: admin_users_path)
      expect(page).to have_link('System Settings', href: admin_settings_path)
    end
    
    it 'shows admin badge' do
      expect(page).to have_css('.admin-badge')
      expect(page).to have_content('Admin')
    end
  end
  
  context 'when authenticated as super admin' do
    let(:super_admin) { create(:user, :super_admin) }
    
    before do
      sign_in super_admin
      visit root_path
    end
    
    it 'shows super admin navigation links' do
      expect(page).to have_link('Super Admin', href: super_admin_dashboard_path)
      expect(page).to have_link('Audit Logs', href: admin_audit_logs_path)
      expect(page).to have_link('System Health', href: admin_health_path)
    end
    
    it 'shows super admin badge' do
      expect(page).to have_css('.super-admin-badge')
      expect(page).to have_content('Super Admin')
    end
  end
end