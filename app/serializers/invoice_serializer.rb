class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :customer_id, :id, :merchant_id, :status
  has_many :transactions
end
