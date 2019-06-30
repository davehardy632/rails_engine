class DateSerializer
  include FastJsonapi::ObjectSerializer
  attributes :best_day

  attribute :best_day do |object|
    object.updated_at.to_s.split(" ").first
  end
end
