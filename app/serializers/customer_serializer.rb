class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :id, :last_name

end
