require 'rails_helper'

describe "Customers Api" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers.json'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers.count).to eq(3)
  end

  it "sends a single customer resource" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}.json"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["id"]).to eq(id)
  end

  describe "sends a resource based on a customer attribute" do
    xit "sends a resource based on customer name" do
      customer = create(:customer)

      get "/api/v1/customers/find?name=#{customer.first_name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer[:name]).to eq(customer.first_name)
    end
  end
end
