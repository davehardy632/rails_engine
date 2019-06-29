class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :items
  has_many :transactions, through: :invoices

  def self.total_revenue(merchant_id)
    InvoiceItem
    .joins(invoice: :transactions)
    .where("invoices.merchant_id = ?", merchant_id)
    .where("transactions.result = ?", "success")
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end
# Invoice.where(merchant_id: merchant_id).joins(:transactions).where("transactions.result = ?", "success").joins(:invoice_items).select("invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue").group("invoices.id")
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

  def self.customer_favorite(customer_id)
    joins(:invoices)
    .where("invoices.customer_id = ?", customer_id["id"])
    .joins(:transactions).where("transactions.result = ?", "success")
    .select("merchants.*, count(transactions.id) as transaction_count")
    .group("merchants.id")
    .order("transaction_count desc")
    .first
  end
end
