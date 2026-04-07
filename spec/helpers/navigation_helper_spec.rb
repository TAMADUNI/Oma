# spec/helpers/navigation_helper_spec.rb
require 'rails_helper'

RSpec.describe NavigationHelper, type: :helper do
  describe '#nav_link_class' do
    it 'returns active class when current page matches' do
      allow(helper).to receive(:current_page?).and_return(true)
      expect(helper.nav_link_class(root_path)).to include('bg-gray-900', 'text-white')
    end
    
    it 'returns inactive class when current page does not match' do
      allow(helper).to receive(:current_page?).and_return(false)
      expect(helper.nav_link_class(root_path)).to include('text-gray-300', 'hover:bg-gray-700')
    end
  end
  
  describe '#user_avatar_initials' do
    let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }
    
    it 'returns first letters of first and last name' do
      expect(helper.user_avatar_initials(user)).to eq('JD')
    end
    
    it 'returns single letter if only first name present' do
      user.last_name = nil
      expect(helper.user_avatar_initials(user)).to eq('J')
    end
  end
  
  describe '#navigation_items' do
    let(:user) { create(:user) }
    
    before do
      allow(helper).to receive(:current_user).and_return(user)
    end
    
    it 'returns public items when not authenticated' do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      items = helper.navigation_items
      
      expect(items).to include({ name: 'Home', path: root_path, public: true })
      expect(items).to include({ name: 'Sign In', path: new_user_session_path, public: true })
    end
    
    it 'returns authenticated items when signed in' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      items = helper.navigation_items
      
      expect(items).to include({ name: 'Dashboard', path: dashboard_path, icon: 'dashboard' })
      expect(items).to include({ name: 'Sign Out', path: destroy_user_session_path, method: :delete })
    end
    
    it 'includes admin items for admin users' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(user).to receive(:admin?).and_return(true)
      
      items = helper.navigation_items
      admin_items = items.select { |item| item[:admin] }
      
      expect(admin_items).not_to be_empty
    end
  end
end