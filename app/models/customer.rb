class Customer < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :invoices
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices

  def self.merchant_favorite(merchant_id)
    joins(:transactions)
    .where("invoices.merchant_id = ?", merchant_id)
    .where("transactions.result = ?", "success")
    .select("customers.*, count(transactions.id) as transaction_number")
    .group(:id)
    .order("transaction_number desc")
    .limit(1)
    .first
  end

  def self.associated_invoice(invoice_id)
    joins(:invoices)
    .where("invoices.id = ?", invoice_id)
    .first
  end

  def self.with_pending_invoices(merchant_id)
    joins(:invoices)
    .where("invoices.merchant_id = ?", merchant_id)
    .where("invoices.status = ?", "pending")
  end
end
