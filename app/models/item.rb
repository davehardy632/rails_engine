class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  # def self.find_by_invoice_id(invoice_item_id)
  #   joins(:invoice_items).select("items.*").where("invoice_items.id = ?", invoice_item_id)
  # end

  def self.for_invoice_item(invoice_item_id)
    joins(:invoice_items)
    .where(invoice_items: {id: invoice_item_id})
    .first
  end

  def self.find_by_invoice_id(invoice_id)
    joins(:invoice_items).where(invoice_items: {invoice_id: invoice_id})
  end
end
