# spec/requests/navigation_authorization_spec.rb
require 'rails_helper'

RSpec.describe 'Navigation Authorization', type: :request do
  describe 'role-based access control' do
    let(:regular_user) { create(:user) }
    let(:admin_user) { create(:user, :admin) }
    let(:super_admin_user) { create(:user, :super_admin) }
    
    context 'admin panel access' do
      it 'allows admin users' do
        sign_in admin_user
        get admin_dashboard_path
        expect(response).to have_http_status(:success)
      end
      
      it 'denies regular users' do
        sign_in regular_user
        get admin_dashboard_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:alert]).to eq('You are not authorized to access this area.')
      end
      
      it 'denies unauthenticated users' do
        get admin_dashboard_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    context 'super admin panel access' do
      it 'allows super admin users' do
        sign_in super_admin_user
        get super_admin_dashboard_path
        expect(response).to have_http_status(:success)
      end
      
      it 'denies regular admin users' do
        sign_in admin_user
        get super_admin_dashboard_path
        expect(response).to redirect_to(admin_dashboard_path)
        follow_redirect!
        expect(flash[:alert]).to eq('Super admin privileges required.')
      end
    end
  end
end