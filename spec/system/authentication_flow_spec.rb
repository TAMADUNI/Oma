# spec/system/authentication_flow_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication Flow', type: :system do
  let(:user) { create(:user) }
  
  it 'allows a user to sign up, sign in, and sign out' do
    # Sign up
    visit new_user_registration_path
    
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'User'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'Password123!'
    fill_in 'Confirm password', with: 'Password123!'
    check 'user_terms_of_service'
    
    click_button 'Sign up'
    
    expect(page).to have_content('Welcome! You have signed up successfully')
    
    # Sign out
    click_link 'Sign out'
    expect(page).to have_content('Signed out successfully')
    
    # Sign in
    visit new_user_session_path
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'
    
    expect(page).to have_content('Signed in successfully')
  end
end