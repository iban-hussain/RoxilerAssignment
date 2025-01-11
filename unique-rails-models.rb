# app/models/concerns/name_validatable.rb
module NameValidatable
  extend ActiveSupport::Concern
  
  included do
    validate :name_format_validation
    
    private
    
    def name_format_validation
      return if name.blank?
      
      if name.length < 20 || name.length > 60
        errors.add(:name, 'must be between 20 and 60 characters')
      end
      
      # Custom validation to ensure name contains both letters and numbers
      unless name.match?(/^(?=.*[a-zA-Z])(?=.*[0-9]).+$/)
        errors.add(:name, 'must contain both letters and numbers')
      end
    end
  end
end

# app/models/user.rb
class User < ApplicationRecord
  include NameValidatable
  
  # Custom enum implementation with authorization scope
  ROLES = {
    regular: 'regular',
    proprietor: 'proprietor',
    supervisor: 'supervisor'
  }.freeze
  
  # Custom authentication token
  has_secure_token :auth_token
  
  # Associations
  has_many :store_ratings, dependent: :destroy
  has_many :rated_stores, through: :store_ratings, source: :store
  has_one :owned_store, class_name: 'Store', foreign_key: 'proprietor_id'
  
  # Validations
  validates :email, presence: true, 
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true, 
                     length: { maximum: 400 },
                     format: { with: /\A[\w\s,.-]+\z/, message: 'contains invalid characters' }
  validate :password_strength
  
  # Scopes
  scope :by_role, ->(role) { where(role: role) }
  scope :active_users, -> { where(active: true) }
  scope :search_by_name, ->(query) { where('name ILIKE ?', "%#{query}%") }
  
  def initialize_role
    self.role ||= ROLES[:regular]
  end
  
  private
  
  def password_strength
    return if password.blank?
    
    unless password.match?(/^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,16}$/)
      errors.add :password, 'must include: 1 uppercase, 1 special character, 1 number, and be 8-16 characters'
    end
  end
end

# app/models/store.rb
class Store < ApplicationRecord
  include NameValidatable
  
  # Associations
  belongs_to :proprietor, class_name: 'User'
  has_many :store_ratings, dependent: :destroy
  has_many :rating_users, through: :store_ratings, source: :user
  
  # Validations
  validates :email, presence: true, 
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true,
                     length: { maximum: 400 }
  validate :unique_proprietor_store
  
  # Scopes
  scope :highly_rated, -> { joins(:store_ratings).group(:id).having('AVG(store_ratings.value) >= ?', 4.0) }
  scope :search_by_location, ->(query) { where('address ILIKE ?', "%#{query}%") }
  
  def rating_statistics
    {
      average: store_ratings.average(:value).to_f.round(2),
      total_ratings: store_ratings.count,
      rating_distribution: store_ratings.group(:value).count,
      recent_ratings: store_ratings.order(created_at: :desc).limit(5)
    }
  end
  
  private
  
  def unique_proprietor_store
    if proprietor.owned_store.present? && proprietor.owned_store != self
      errors.add(:proprietor, 'already owns a different store')
    end
  end
end

# app/models/store_rating.rb
class StoreRating < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :store
  
  # Validations
  validates :value, presence: true, 
                   inclusion: { in: 1..5, message: 'must be between 1 and 5' }
  validates :user_id, uniqueness: { 
    scope: :store_id, 
    message: 'has already rated this store' 
  }
  validate :cannot_rate_own_store
  
  # Callbacks
  after_save :update_store_average_rating
  after_destroy :update_store_average_rating
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_value, ->(value) { where(value: value) }
  
  private
  
  def cannot_rate_own_store
    if store.proprietor_id == user_id
      errors.add(:base, 'Store owners cannot rate their own stores')
    end
  end
  
  def update_store_average_rating
    store.update_column(:average_rating, store.store_ratings.average(:value))
  end
end
