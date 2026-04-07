# spec/requests/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /users/sign_in' do
    let(:user) { create(:user) }
    
    context 'with valid credentials' do
      it 'signs in the user and redirects to root path' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'Password123!'
          }
        }
        
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Signed in successfully')
      end
      
      it 'sets the session' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'Password123!'
          }
        }
        
        expect(session['warden.user.user.key']).to be_present
      end
    end
    
    context 'with invalid credentials' do
      it 'returns unprocessable entity' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Invalid Email or password')
      end
    end
    
    context 'with inactive account' do
      let(:inactive_user) { create(:user, :inactive) }
      
      it 'prevents login' do
        post user_session_path, params: {
          user: {
            email: inactive_user.email,
            password: 'Password123!'
          }
        }
        
        expect(response.body).to include('Your account is inactive')
      end
    end
  end
  
  describe 'DELETE /users/sign_out' do
    let(:user) { create(:user) }
    
    before do
      sign_in user
    end
    
    it 'signs out the user' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Signed out successfully')
    end
  end
  
  describe 'POST /users/password' do
    let(:user) { create(:user) }
    
    it 'sends password reset instructions' do
      expect {
        post user_password_path, params: {
          user: { email: user.email }
        }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:notice]).to eq('You will receive an email with instructions about how to reset your password in a few minutes.')
    end
  end
end