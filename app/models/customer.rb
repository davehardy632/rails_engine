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

  def transactions
    invoices
    .joins(:transactions)
    .select("transactions.*")
  end

  def self.associated_invoice(invoice_id)
    joins(:invoices)
    .where("invoices.id = ?", invoice_id)
    .first
  end

  def self.with_pending_invoices(merchant_params)
    find_by_sql(["SELECT customers.* FROM customers RIGHT JOIN invoices ON invoices.customer_id = customers.id JOIN merchants ON invoices.merchant_id = merchants.id WHERE (invoices.merchant_id = '#{merchant_params["id"]}') AND invoices.id NOT IN (SELECT transactions.invoice_id FROM transactions WHERE transactions.result = 'success')", 'customers.id'])
   end
end
