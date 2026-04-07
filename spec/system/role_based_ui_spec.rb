# spec/system/role_based_ui_spec.rb
require 'rails_helper'

RSpec.describe "Role-based UI", type: :system do
  let(:employee) { create(:user, :employee) }
  let(:team_leader) { create(:user, :team_leader) }
  let(:operation_manager) { create(:user, :operation_manager) }
  let(:hr_manager) { create(:user, :hr_manager) }
  
  describe "Employee view" do
    before do
      sign_in employee
      visit root_path
    end
    
    it "shows only own performance data" do
      expect(page).to have_content("My Performance")
      expect(page).not_to have_content("Team Performance")
      expect(page).not_to have_content("HR Dashboard")
    end
    
    it "allows logging daily tasks" do
      click_link "Log Task"
      expect(page).to have_content("New Task Log")
    end
    
    it "shows personal PDI score" do
      click_link "My PDI Report"
      expect(page).to have_content("Annual Performance Score")
    end
    
    it "shows task history" do
      click_link "My Task History"
      expect(page).to have_content("Tasks Performed")
    end
    
    it "does not show admin menu" do
      expect(page).not_to have_link("Admin Dashboard")
      expect(page).not_to have_link("Manage Employees")
    end
  end
  
  describe "Team Leader view" do
    let!(:team_members) { create_list(:user, 3, :employee, supervisor: team_leader) }
    
    before do
      sign_in team_leader
      visit root_path
    end
    
    it "shows team performance tab" do
      expect(page).to have_content("Team Performance")
      expect(page).to have_content("My Team")
    end
    
    it "shows team leader specific dashboard" do
      expect(page).to have_content("Team Leader Dashboard")
      expect(page).to have_content("Team Members: 3")
    end
    
    it "allows viewing team members' task logs" do
      click_link "Team Task Logs"
      expect(page).to have_content("Team Tasks")
    end
    
    it "allows viewing team members' PDI" do
      click_link "Team PDI Report"
      expect(page).to have_content("Team Performance Summary")
    end
    
    it "does not show HR functions" do
      expect(page).not_to have_link("HR Dashboard")
      expect(page).not_to have_link("Manage Roles")
    end
  end
  
  describe "Operation Manager view" do
    before do
      sign_in operation_manager
      visit root_path
    end
    
    it "shows operations dashboard" do
      expect(page).to have_content("Operations Dashboard")
      expect(page).to have_content("Overall Equipment Efficiency")
    end
    
    it "shows all teams performance" do
      expect(page).to have_content("All Teams Performance")
    end
    
    it "allows managing PDI settings" do
      click_link "PDI Settings"
      expect(page).to have_content("Configure Task Weights")
      expect(page).to have_content("Set Performance Targets")
    end
    
    it "shows maintenance analytics" do
      expect(page).to have_content("Maintenance Analytics")
      expect(page).to have_content("Preventive vs Corrective")
    end
    
    it "shows department-wide task logs" do
      expect(page).to have_content("Department Task Summary")
    end
    
    it "does not show HR functions" do
      expect(page).not_to have_link("Employee Management")
      expect(page).not_to have_link("Recruitment")
    end
  end
  
  describe "HR Manager view" do
    before do
      sign_in hr_manager
      visit root_path
    end
    
    it "shows HR dashboard" do
      expect(page).to have_content("HR Dashboard")
      expect(page).to have_content("Employee Lifecycle")
    end
    
    it "allows managing all employees" do
      click_link "All Employees"
      expect(page).to have_content("Employee Directory")
    end
    
    it "allows managing roles and promotions" do
      click_link "Role Management"
      expect(page).to have_content("Promotion Recommendations")
    end
    
    it "shows PDI reports for all employees" do
      click_link "Company-wide PDI"
      expect(page).to have_content("Performance Distribution")
    end
    
    it "shows training needs analysis" do
      expect(page).to have_content("Training Recommendations")
    end
    
    it "allows viewing all task logs" do
      click_link "All Task Logs"
      expect(page).to have_content("Company Task History")
    end
  end
end