class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions

  validates_presence_of :quantity
  validates_presence_of :unit_price

  def self.find_by_invoice(invoice_id)
    where(invoice_id: invoice_id).joins(:invoice)
  end

  def self.associated_item(item_id)
    binding.pry

  end
end
