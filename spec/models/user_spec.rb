require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes ' do
    user = build(:user)
    except(user).to be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    except(user).to_not be_valid
  end
end
