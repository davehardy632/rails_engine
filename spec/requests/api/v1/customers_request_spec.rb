require 'rails_helper'

describe "Customers Api" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers.json'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq(3)
  end

  it "sends a single customer resource" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}.json"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"].to_i).to eq(id)
  end

  describe "sends a resource based on a customer attribute" do
    it "sends a resource based on customer name" do
      starting_customer = create(:customer)

      get "/api/v1/customers/find?first_name=#{starting_customer.first_name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful

      expect(customer["data"]["attributes"]["first_name"]).to eq(starting_customer.first_name)
    end

    it "sends a resource based on a customer id" do
      starting_customer = create(:customer)

      get "/api/v1/customers/find?id=#{starting_customer.id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful

      expect(customer["data"]["id"].to_i).to eq(starting_customer.id)
    end

    it "sends a resource based on customer last name" do
      starting_customer = create(:customer)

      get "/api/v1/customers/find?last_name=#{starting_customer.last_name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful

      expect(customer["data"]["attributes"]["last_name"]).to eq(starting_customer.last_name)
    end

    it "sends a resource based on customer created at date" do
      starting_customer = create(:customer, created_at: "2012-03-27T14:54:05.000Z")

      get "/api/v1/customers/find?created_at=#{starting_customer.created_at}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["data"]["id"].to_i).to eq(starting_customer.id)
    end

    it "sends a resource based on customer updated_at date" do
      starting_customer = create(:customer, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2012-03-30T14:54:05.000Z")

      get "/api/v1/customers/find?updated_at=#{starting_customer.updated_at}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["data"]["id"].to_i).to eq(starting_customer.id)
    end
  end
end
