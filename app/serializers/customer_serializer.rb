class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :created_at, :updated_at
  has_many :invoices
end
