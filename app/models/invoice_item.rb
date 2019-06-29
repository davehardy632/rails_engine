class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions

  validates_presence_of :quantity
  validates_presence_of :unit_price

  def self.find_by_invoice(invoice_id)
    where(invoice_id: invoice_id).joins(:invoice)
  end

  def self.associated_item(item_id)
    where("invoice_items.item_id = ?", item_id)
  end

  def self.find_all_by_invoice(invoice_id)
    where(invoice_id: invoice_id)
  end
# this method is for endpoint test invoice item
  def self.first_instance_by_attribute(key, value)
    if key == "unit_price"
      # new_value = (value.to_f * 100).to_i
      self.where(key => ((value.to_f * 100).to_i)).order(id: "asc").first
    else
      self.where(key => value).order(id: "asc").first
    end
  end

  def self.find_all_by_attribute(key, value)
    if key == "unit_price"
      # new_value = (value.to_f * 100).to_i
      self.where(key => ((value.to_f * 100).to_i)).order(id: "asc")
    else
      self.where(key => value).order(id: "asc")
    end
  end

end
