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
  end

    describe "associations" do
    it { should have_many(:task_logs).with_foreign_key('employee_id').dependent(:nullify) }
    it { should have_many(:behavior_scores).dependent(:destroy) }
    it { should have_many(:quality_issues).through(:task_logs) }
  end
end
