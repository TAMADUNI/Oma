# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:user) }
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_acceptance_of(:terms_of_service) }
    it { should validate_presence_of(:role) }
    
    it do
      should define_enum_for(:role)
        .with_values([:user, :admin, :super_admin])
        .backed_by_column_of_type(:string)
    end
  end

  describe 'callbacks' do
    context 'before_create' do
      it 'sets default role to user if not specified' do
        user = create(:user, role: nil)
        expect(user.role).to eq('user')
      end

      it 'normalizes email' do
        user = create(:user, email: '  TEST@EXAMPLE.COM  ')
        expect(user.email).to eq('test@example.com')
      end
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    
    describe '#full_name' do
      it 'returns concatenated first and last name' do
        expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
      end
    end

    describe '#admin?' do
      it 'returns true for admin users' do
        admin = create(:user, :admin)
        expect(admin.admin?).to be true
      end

      it 'returns false for regular users' do
        expect(user.admin?).to be false
      end
    end
  end

  describe 'scopes' do
    describe '.active' do
      it 'returns only active users' do
        active_user = create(:user, active: true)
        inactive_user = create(:user, active: false)
        
        expect(User.active).to include(active_user)
        expect(User.active).not_to include(inactive_user)
      end
    end
  end
end