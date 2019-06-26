  class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :credit_card_number, :id, :invoice_id, :result
  belongs_to :invoice
end
