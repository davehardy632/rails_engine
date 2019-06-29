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
    where("invoice_items.item_id = ?", item_id)
  end

  def self.find_all_by_invoice(invoice_id)
    where(invoice_id: invoice_id)
  end

  def self.first_instance_by_id(invoice_item_id)
    where(id: invoice_item_id).first
  end
end
