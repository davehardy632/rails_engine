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

    it "returns invoices from a customers id" do
      customer = create(:customer)
      merchant = create(:merchant)
      start_invoices = create_list(:invoice, 3, customer: customer, merchant: merchant)

      get "/api/v1/customers/#{customer.id}/invoices"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices["data"].count).to eq(3)
    end

    it "loads a collection of transactions for a customer" do
      customer = create(:customer)
      merchant = create(:merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      start_transactions = create_list(:transaction, 3, invoice: invoice)

      get "/api/v1/customers/#{customer.id}/transactions"

      transactions = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "finds all customers by an id" do
      customer = create(:customer)

      get "/api/v1/customers/find_all?id=#{customer.id}"

      end_customers = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "finds all customers by first_name" do
      customer = create(:customer, first_name: "John")
      customer_2 = create(:customer, first_name: "John")

      get "/api/v1/customers/find_all?first_name=#{customer.first_name}"

      end_customers = JSON.parse(response.body)

      expect(response).to be_successful
      expect(end_customers["data"].count).to eq(2)
      expect(end_customers["data"].first["attributes"]["first_name"]).to eq("John")
      expect(end_customers["data"].second["attributes"]["first_name"]).to eq("John")
    end
  end

  describe "customer business logic" do
    it "loads the favorite merchant associated with a customer id" do
      customer = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)


      # one invoice for each new merchant, same customer
      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer)
      # merchant 2 invoice
      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer)
      #merchant 3 invoice
      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer)

      # transactions 1-3 associated with merchant 1 through invoice 1
      transaction_1 = create(:transaction, invoice: invoice_1)
      transaction_2 = create(:transaction, invoice: invoice_1)
      transaction_3 = create(:transaction, invoice: invoice_1)
      # transaction 4 associated with merchant 2 through invoice 2
      transaction_4 = create(:transaction, invoice: invoice_2)
      # transactions 5-7 associated with merchant 3 through invoice 3 one of which is not successful
      transaction_5 = create(:transaction, invoice: invoice_3)
      transaction_6 = create(:transaction, invoice: invoice_3)
      transaction_7 = create(:transaction, invoice: invoice_3)

      get "/api/v1/customers/#{customer.id}/favorite_merchant"

      fav_merchant = JSON.parse(response.body)

      expect(response).to be_successful
    end
  end
end
