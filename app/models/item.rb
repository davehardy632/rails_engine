class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.find_by_invoice_id(invoice_id)
    joins(:invoice_items)
    .where(invoice_items: {invoice_id: invoice_id})
  end

  def self.by_invoice_item(invoice_item_id)
    joins(:invoice_items)
    .where("invoice_items.id = ?", invoice_item_id)
    .first
  end

  def self.first_instance_by_attribute(key, value)
    if key == "unit_price"
      where(key => ((value.to_f * 100).round))
      .order(id: "asc")
      .first
    else
      where(key => value)
      .order(id: "asc")
      .first
    end
  end

  def self.find_all_by_attribute(key, value)
    if key == "unit_price"
      where(key => ((value.to_f * 100).round))
      .order(id: "asc")
    else
      where(key => value)
      .order(id: "asc")
    end
  end

  def self.best_day(item_params)
    joins(invoices: :transactions)
    .select("invoices.updated_at, sum(invoice_items.quantity) as items")
    .where("items.id = ?", item_params["id"])
    .where("transactions.result = ?", "success")
    .group("invoices.id")
    .order("items desc")
    .order("invoices.updated_at desc")
    .take
  end

  def self.top_by_items_sold(item_params)
    joins(invoices: :transactions)
    .select("items.*, sum(invoice_items.quantity) as items_sold")
    .where("transactions.result = ?", "success")
    .group("items.id")
    .order("items_sold desc")
    .limit(item_params["quantity"].to_i)
  end

  def self.ranked_by_revenue(item_params)
    joins(invoices: :transactions)
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("transactions.result = ?", "success")
    .group("items.id")
    .order("revenue desc")
    .limit(item_params["quantity"].to_i)
  end
end
