require 'rails_helper'

RSpec.describe User, type: :model do

    describe 'validate' do 
        it { should validate_presence_of(:email) }
        it { should validate_uniqueness_of(:email) }
        it { should allow_value('juma@example.com', juma.masudi@example.com).for(:email)}
    end
  
end
