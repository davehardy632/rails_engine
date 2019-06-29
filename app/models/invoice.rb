class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  def self.by_invoice_item(invoice_item_id)
    joins(:invoice_items)
    .where(invoice_items: {id: invoice_item_id})
    .first
  end

  def self.associated_transacton(transaction_id)
    joins(:transactions)
    .where("transactions.id = ?", transaction_id)
    .first
  end

  def self.first_instance_by_attribute(key, value)
    where(key => value)
    .order(id: "asc")
    .first
  end

  def self.find_all_by_attribute(key, value)
    if key == "unit_price"
      where(key => ((value.to_f * 100).to_i))
      .order(id: "asc")
    else
      where(key => value)
      .order(id: "asc")
    end
  end
end
