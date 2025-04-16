require 'rails_helper'

RSpec.describe User, type: :model do

    describe 'validate' do 
        it { should validate_presence_of(:name) }
    end
  
end
