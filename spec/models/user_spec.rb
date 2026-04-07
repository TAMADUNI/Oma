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
end
