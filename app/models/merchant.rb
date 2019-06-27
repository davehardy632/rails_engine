class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :items
  has_many :transactions, through: :invoices

  # attr_reader :name, :created_at, :updated_at
  #
  # def initialize(name)
  #   @name = name
  #   @created_at = created_at
  #   @updated_at = updated_at
  # end
  # def self.total_revenue(merchant_id)
  # result = Invoice.joins(:transactions, :invoice_items)
  #    .where("transactions.result = ?", "success")
  #    .where("invoices.merchant_id = ?", merchant_id)
  #    .select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
  #    .group(:id)
  #    binding.pry
  # end

  def self.total_revenue(merchant_id)
    Invoice.joins(:transactions, :invoice_items)
    .where("invoices.merchant_id = ?", merchant_id)
    .where("transactions.result = ?", "success")
    .sum("invoice_items.quantity * invoice_items.unit_price / 100").round(2)
  end


end
