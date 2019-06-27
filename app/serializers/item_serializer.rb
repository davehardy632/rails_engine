class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :merchant_id, :name, :description, :unit_price

  belongs_to :merchant
end
