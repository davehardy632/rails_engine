class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
   ((Merchant.total_revenue(object.id)).to_f / 100).to_s
  end
end
