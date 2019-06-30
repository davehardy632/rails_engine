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

  def self.top_ranked(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("revenue desc")
    .limit(quantity["quantity"])
  end

  def self.top_ranked_by_items(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .select("merchants.*, sum(invoice_items.quantity) as items_sold")
    .where("transactions.result = ?", "success")
    .group("merchants.id")
    .order("items_sold desc")
    .limit(quantity["quantity"])
  end

  def self.total_revenue_all(date)
    Merchant
    .joins(invoices: [:invoice_items, :transactions])
    .select("sum(invoice_items.quantity *  invoice_items.unit_price) as revenue")
    .where("transactions.result = ?", "success")
    .where("CAST(invoices.updated_at as char(10)) like ?", "#{date["date"]}%")
    .take
  end

  def total_revenue(date = 0)
    if date != 0
      Merchant
      .joins(invoices: [:invoice_items, :transactions])
      .select("merchants.*, sum(invoice_items.quantity *  invoice_items.unit_price) as revenue")
      .where("transactions.result = ?", "success")
      .where("CAST(invoices.updated_at as char(10)) like ?", "#{date["date"]}%")
      .where("merchants.id = ?", self.id)
      .group("merchants.id")
      .take
    else
      Merchant
      .joins(invoices: [:invoice_items, :transactions])
      .select("merchants.*, sum(invoice_items.quantity *  invoice_items.unit_price) as revenue")
      .where("transactions.result = ?", "success")
      .where("merchants.id = ?", self.id)
      .group("merchants.id")
      .take
    end
  end

  def self.revenue_by_date(info)
    merchant_id = info["id"]
    date = info["date"]
    InvoiceItem
    .joins(invoice: :transactions)
    .where("invoices.merchant_id = ?", merchant_id)
    .where("invoices.updated_at = ?", date)
    .where("transactions.result = ?", "success")
    .sum("invoice_items.quantity * invoice_items.unit_price")
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
