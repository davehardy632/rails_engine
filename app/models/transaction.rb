class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :invoice_items
  validates_presence_of :credit_card_number
  validates_presence_of :result

  def self.return_invoices(invoice_id)
    joins(:invoice).where(invoices: {id: invoice_id})
  end
end
