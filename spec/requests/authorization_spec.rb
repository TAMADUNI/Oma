# spec/requests/authorization_spec.rb
require 'rails_helper'

RSpec.describe "Authorization", type: :request do
  let(:employee) { create(:user, :employee) }
  let(:team_leader) { create(:user, :team_leader) }
  let(:operation_manager) { create(:user, :operation_manager) }
  let(:hr_manager) { create(:user, :hr_manager) }
  let(:admin) { create(:user, :admin) }
  
  # Create hierarchy
  let!(:employee_under_tl) { create(:user, :employee, supervisor: team_leader) }
  let!(:tl_under_om) { create(:user, :team_leader, supervisor: operation_manager) }
  let!(:employee_under_om) { create(:user, :employee, supervisor: tl_under_om) }
  
  describe "Access to employee list" do
    it "allows hr_manager to access" do
      sign_in hr_manager
      get employees_path
      expect(response).to have_http_status(:success)
    end
    
    it "allows operation_manager to access" do
      sign_in operation_manager
      get employees_path
      expect(response).to have_http_status(:success)
    end
    
    it "allows team_leader to access" do
      sign_in team_leader
      get employees_path
      expect(response).to have_http_status(:success)
    end
    
    it "denies employee to access" do
      sign_in employee
      get employees_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to access this page.")
    end
  end
  
  describe "Access to employee data" do
    it "allows team_leader to see their team member's data" do
      sign_in team_leader
      get employee_path(employee_under_tl)
      expect(response).to have_http_status(:success)
    end
    
    it "denies team_leader to see other team's employee data" do
      other_employee = create(:user, :employee)
      sign_in team_leader
      get employee_path(other_employee)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You can only view your own team's data.")
    end
    
    it "allows operation_manager to see data across teams" do
      sign_in operation_manager
      get employee_path(employee_under_tl)
      expect(response).to have_http_status(:success)
    end
    
    it "allows hr_manager to see any employee data" do
      sign_in hr_manager
      get employee_path(employee_under_tl)
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "Access to edit employee data" do
    it "allows hr_manager to edit any employee" do
      sign_in hr_manager
      get edit_employee_path(employee)
      expect(response).to have_http_status(:success)
    end
    
    it "allows admin to edit any employee" do
      sign_in admin
      get edit_employee_path(employee)
      expect(response).to have_http_status(:success)
    end
    
    it "denies operation_manager to edit employees" do
      sign_in operation_manager
      get edit_employee_path(employee)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You are not authorized to edit employee data.")
    end
    
    it "denies team_leader to edit employees" do
      sign_in team_leader
      get edit_employee_path(employee_under_tl)
      expect(response).to redirect_to(root_path)
    end
  end
  
  describe "Access to PDI reports" do
    it "allows team_leader to see team members' PDI" do
      sign_in team_leader
      get employee_pdi_path(employee_under_tl)
      expect(response).to have_http_status(:success)
    end
    
    it "denies team_leader to see other team's PDI" do
      other_employee = create(:user, :employee)
      sign_in team_leader
      get employee_pdi_path(other_employee)
      expect(response).to redirect_to(root_path)
    end
    
    it "allows operation_manager to see all operational employees' PDI" do
      sign_in operation_manager
      get employee_pdi_path(employee_under_tl)
      expect(response).to have_http_status(:success)
    end
    
    it "allows hr_manager to see all PDI reports" do
      sign_in hr_manager
      get all_employees_pdi_path
      expect(response).to have_http_status(:success)
    end
    
    it "denies employee to see other employee's PDI" do
      sign_in employee
      get employee_pdi_path(employee_under_tl)
      expect(response).to redirect_to(root_path)
    end
  end
  
  describe "Access to PDI management (setting weights, targets)" do
    it "allows operation_manager to manage PDI settings" do
      sign_in operation_manager
      get pdi_settings_path
      expect(response).to have_http_status(:success)
    end
    
    it "allows hr_manager to manage PDI settings" do
      sign_in hr_manager
      get pdi_settings_path
      expect(response).to have_http_status(:success)
    end
    
    it "denies team_leader to manage PDI settings" do
      sign_in team_leader
      get pdi_settings_path
      expect(response).to redirect_to(root_path)
    end
    
    it "denies employee to manage PDI settings" do
      sign_in employee
      get pdi_settings_path
      expect(response).to redirect_to(root_path)
    end
  end
  
  describe "Access to HR operations (hiring, firing, promotions)" do
    it "allows hr_manager to access HR operations" do
      sign_in hr_manager
      get hr_dashboard_path
      expect(response).to have_http_status(:success)
    end
    
    it "allows admin to access HR operations" do
      sign_in admin
      get hr_dashboard_path
      expect(response).to have_http_status(:success)
    end
    
    it "denies operation_manager to access HR operations" do
      sign_in operation_manager
      get hr_dashboard_path
      expect(response).to redirect_to(root_path)
    end
    
    it "denies team_leader to access HR operations" do
      sign_in team_leader
      get hr_dashboard_path
      expect(response).to redirect_to(root_path)
    end
  end
  
  describe "Team management" do
    it "allows team_leader to view their team" do
      sign_in team_leader
      get team_path(team_leader)
      expect(response).to have_http_status(:success)
      expect(assigns(:team_members)).to include(employee_under_tl)
    end
    
    it "allows operation_manager to view all teams" do
      sign_in operation_manager
      get teams_path
      expect(response).to have_http_status(:success)
    end
    
    it "denies employee to view team management" do
      sign_in employee
      get teams_path
      expect(response).to redirect_to(root_path)
    end
  end
  
  describe "Access to task logs" do
    it "allows employee to create their own task logs" do
      sign_in employee
      get new_task_log_path
      expect(response).to have_http_status(:success)
    end
    
    it "allows team_leader to view team members' task logs" do
      sign_in team_leader
      get task_logs_path(employee_id: employee_under_tl.id)
      expect(response).to have_http_status(:success)
    end
    
    it "denies employee to view other employee's task logs" do
      sign_in employee
      get task_logs_path(employee_id: employee_under_tl.id)
      expect(response).to redirect_to(root_path)
    end
  end
end