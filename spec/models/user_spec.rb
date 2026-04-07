require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Devise module" do 
    it "includes database_authenticatable module" do
      expect(User.ancestors).to include(Devise::Models::DatabaseAuthenticatable)
    end
    
    it "includes registerable module" do
      expect(User.ancestors).to include(Devise::Models::Registerable)
    end
    
    it "includes recoverable module" do
      expect(User.ancestors).to include(Devise::Models::Recoverable)
    end

    it "includes rememberable module" do
      expect(User.ancestors).to include(Devise::Models::Rememberable)
    end
    
    it "includes validatable module" do
      expect(User.ancestors).to include(Devise::Models::Validatable)
    end
  end

  describe "validations" do
    subject { build(:user) }
    
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_presence_of(:role) }
    it { should validate_inclusion_of(:role).in_array(%w[employee team_leader operation_manager hr_manager admin]) }
  end

    describe "associations" do
    it { should belong_to(:supervisor).class_name('User').optional }
    it { should have_many(:subordinates).class_name('User').with_foreign_key('supervisor_id') }
    it { should have_many(:task_logs).with_foreign_key('employee_id').dependent(:nullify) }
    it { should have_many(:behavior_scores).dependent(:destroy) }
    it { should have_many(:quality_issues).through(:task_logs) }
    it { should have_many(:approved_task_logs).class_name('TaskLog').with_foreign_key('approver_id') }
  end
  
  describe "enums" do
    it { should define_enum_for(:role).with_values(employee: 0, team_leader: 1, operation_manager: 2, hr_manager: 3, admin: 4) }
  end
  
   describe "custom methods" do
    let(:user) { create(:user) }
    
    describe "#employee?" do
      it "returns true for employee role" do
        user.employee!
        expect(user.employee?).to be true
      end
      
      it "returns false for admin role" do
        user.admin!
        expect(user.employee?).to be false
      end
    end
end
