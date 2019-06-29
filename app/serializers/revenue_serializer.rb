class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
  result = (Merchant.total_revenue(object.id))
  end
end
