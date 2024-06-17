class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def total
    order_items.sum(&:total)
  end
end
