# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_many :sessions, dependent: :destroy

  enum role: {
    user: 'user',
    admin: 'admin',
    super_admin: 'super_admin'
  }

  validates :first_name, :last_name, presence: true
  validates :terms_of_service, acceptance: true
  validates :role, presence: true

  before_create :set_default_role
  before_save :normalize_email

  scope :active, -> { where(active: true) }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    admin? || super_admin?
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    active? ? super : :inactive_account
  end

  private

  def set_default_role
    self.role ||= :user
  end

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end