class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :items
  has_many :transactions, through: :invoices

  def self.total_revenue(merchant_id)
    Invoice.joins(:transactions, :invoice_items)
    .where("invoices.merchant_id = ?", merchant_id)
    .where("transactions.result = ?", "success")
    .sum("invoice_items.quantity * invoice_items.unit_price / 100")
    .round(2)
  end

  def self.associated_invoice(invoice_id)
    joins(:invoices)
    .where(invoices: {id: invoice_id})
    .first
  end

  def self.by_associated_item(item_id)
    joins(:items)
    .where("items.id = ?", item_id)
    .first
  end
end
