# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Devise modules" do
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
  end
  
  describe "enums" do
    it { should define_enum_for(:role).with_values(employee: 0, team_leader: 1, operation_manager: 2, hr_manager: 3, admin: 4) }
  end
  
  describe "role-based methods" do
    let(:employee) { create(:user, :employee) }
    let(:team_leader) { create(:user, :team_leader) }
    let(:operation_manager) { create(:user, :operation_manager) }
    let(:hr_manager) { create(:user, :hr_manager) }
    let(:admin) { create(:user, :admin) }
    
    describe "#employee?" do
      it "returns true for employee" do
        expect(employee.employee?).to be true
      end
      
      it "returns false for other roles" do
        expect(team_leader.employee?).to be false
        expect(operation_manager.employee?).to be false
        expect(hr_manager.employee?).to be false
        expect(admin.employee?).to be false
      end
    end
    
    describe "#team_leader?" do
      it "returns true for team_leader" do
        expect(team_leader.team_leader?).to be true
      end
      
      it "returns false for other roles" do
        expect(employee.team_leader?).to be false
        expect(operation_manager.team_leader?).to be false
      end
    end
    
    describe "#operation_manager?" do
      it "returns true for operation_manager" do
        expect(operation_manager.operation_manager?).to be true
      end
    end
    
    describe "#hr_manager?" do
      it "returns true for hr_manager" do
        expect(hr_manager.hr_manager?).to be true
      end
    end
    
    describe "#admin?" do
      it "returns true for admin" do
        expect(admin.admin?).to be true
      end
    end
    
    describe "#can_manage_team?" do
      it "returns true for team_leader and above" do
        expect(team_leader.can_manage_team?).to be true
        expect(operation_manager.can_manage_team?).to be true
        expect(hr_manager.can_manage_team?).to be true
        expect(admin.can_manage_team?).to be true
        expect(employee.can_manage_team?).to be false
      end
    end
    
    describe "#can_manage_operations?" do
      it "returns true for operation_manager and above" do
        expect(operation_manager.can_manage_operations?).to be true
        expect(hr_manager.can_manage_operations?).to be true
        expect(admin.can_manage_operations?).to be true
        expect(employee.can_manage_operations?).to be false
        expect(team_leader.can_manage_operations?).to be false
      end
    end
    
    describe "#can_manage_hr?" do
      it "returns true for hr_manager and admin" do
        expect(hr_manager.can_manage_hr?).to be true
        expect(admin.can_manage_hr?).to be true
        expect(employee.can_manage_hr?).to be false
        expect(team_leader.can_manage_hr?).to be false
        expect(operation_manager.can_manage_hr?).to be false
      end
    end
  end
  
  describe "supervisor hierarchy" do
    let(:employee) { create(:user, :employee) }
    let(:team_leader) { create(:user, :team_leader) }
    let(:operation_manager) { create(:user, :operation_manager) }
    let(:hr_manager) { create(:user, :hr_manager) }
    
    before do
      employee.update!(supervisor: team_leader)
      team_leader.update!(supervisor: operation_manager)
      operation_manager.update!(supervisor: hr_manager)
    end
    
    describe "#direct_supervisor" do
      it "returns direct supervisor" do
        expect(employee.direct_supervisor).to eq(team_leader)
      end
    end
    
    describe "#team" do
      it "returns subordinates" do
        expect(team_leader.team).to include(employee)
      end
    end
    
    describe "#can_view_employee_data?" do
      it "allows team_leader to view team member data" do
        expect(team_leader.can_view_employee_data?(employee)).to be true
      end
      
      it "allows operation_manager to view team_leader's team" do
        expect(operation_manager.can_view_employee_data?(employee)).to be true
      end
      
      it "allows hr_manager to view all employees" do
        expect(hr_manager.can_view_employee_data?(employee)).to be true
      end
      
      it "denies employee to view colleague data" do
        colleague = create(:user, :employee)
        expect(employee.can_view_employee_data?(colleague)).to be false
      end
      
      it "allows employee to view own data" do
        expect(employee.can_view_employee_data?(employee)).to be true
      end
    end
    
    describe "#can_manage_pdi?" do
      it "allows operation_manager to manage PDI" do
        expect(operation_manager.can_manage_pdi?).to be true
      end
      
      it "allows hr_manager to manage PDI" do
        expect(hr_manager.can_manage_pdi?).to be true
      end
      
      it "allows admin to manage PDI" do
        expect(admin.can_manage_pdi?).to be true
      end
      
      it "denies team_leader to manage PDI" do
        expect(team_leader.can_manage_pdi?).to be false
      end
    end
  end
end