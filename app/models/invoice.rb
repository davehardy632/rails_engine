class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  def self.invoice_by_invoice_item(invoice_item_id)
    joins(:invoice_items).where(invoice_items: {id: invoice_item_id}).first
  end
end
