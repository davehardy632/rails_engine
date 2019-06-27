class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
    (Merchant.total_revenue(object.id))
  end
end
