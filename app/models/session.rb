# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user
  
  validates :session_token, presence: true, uniqueness: true
  
  before_create :generate_session_token
  
  def active?
    active && last_activity_at > 30.days.ago
  end
  
  private
  
  def generate_session_token
    self.session_token = SecureRandom.hex(32)
  end
end