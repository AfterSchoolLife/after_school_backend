class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :schedule, optional: true
  belongs_to :product, optional: true
  validate :product_or_schedule_present
  validates :user_id, presence: true
  validates :cart_type, presence: true
  validates :cart_type, inclusion: { in: %w(cart_product cart_schedule),message: "%{value} is not a valid type" }

  private
  def product_or_schedule_present
    unless product_id.present? ^ schedule_id.present?
      errors.add(:base, 'Must have either a product or a schedule, but not both')
    end
  end
end
