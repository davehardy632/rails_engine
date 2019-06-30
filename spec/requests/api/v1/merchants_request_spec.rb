require 'rails_helper'

describe "Merchants Api" do
  it "sends a list of items" do
    create_list(:merchant, 3)

    get '/api/v1/merchants.json'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(3)
  end

  it "sends a single merchant resource" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}.json"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"].to_i).to eq(id)
  end

  describe "sends a resource based on a merchant attribute" do
    it "sends a resource based on merchant name" do
      starting_merchant = create(:merchant)

      get "/api/v1/merchants/find?name=#{starting_merchant.name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful

      expect(merchant["data"]["attributes"]["name"]).to eq(starting_merchant.name)
    end

    it "sends a resource based on merchant created at date" do
      starting_merchant = create(:merchant, created_at: "2012-03-27T14:54:05.000Z")

      get "/api/v1/merchants/find?created_at=#{starting_merchant.created_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["id"].to_i).to eq(starting_merchant.id)
    end

    it "sends a resource based on merchant updated_at date" do
      starting_merchant = create(:merchant, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2012-03-30T14:54:05.000Z")

      get "/api/v1/merchants/find?updated_at=#{starting_merchant.updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["id"].to_i).to eq(starting_merchant.id)
    end

    it "sends a random merchant record when random is passed in the url" do
      create_list(:merchant, 3)

      get "/api/v1/merchants/random.json"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]).to include("name")
    end
  end

  describe "Returns all instances by given attributes" do
    it "returns all instances of merchant by id" do
      merchants = create_list(:merchant, 3)

      first_merchant = merchants.first

      get "/api/v1/merchants/find_all?id=#{first_merchant.id}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["id"].to_i).to eq(first_merchant.id)
    end


    it "returns all instances of merchant by name" do
      merchant_1 = create(:merchant, name: "john")
      merchant_2 = create(:merchant, name: "bill")
      merchant_3 = create(:merchant, name: "laura")

      get "/api/v1/merchants/find_all?name=#{merchant_1.name}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["attributes"]["name"]).to eq(merchant_1.name)
    end

    it "returns all instances of merchant by created at date" do
      merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:09.000Z")
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      get "/api/v1/merchants/find_all?created_at=#{merchant_1.created_at}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["attributes"]["name"]).to eq(merchant_1.name)
    end

    it "returns all instances of merchant by created at date" do
      merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:09.000Z", updated_at: "2012-03-27T14:54:09.000Z")
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      get "/api/v1/merchants/find_all?created_at=#{merchant_1.updated_at}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["attributes"]["name"]).to eq(merchant_1.name)
    end

    it "returns items associated with one merchant" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/items"

      items = JSON.parse(response.body)

      expect(response).to be_successful
      expect(items["data"].count).to eq(3)
    end

    it "returns invoices associated with a merchant" do
      merchant = create(:merchant)
      customer = create(:customer)

      invoice_1 = create(:invoice, merchant: merchant, customer: customer)
      invoice_2 = create(:invoice, merchant: merchant, customer: customer)
      invoice_3 = create(:invoice, merchant: merchant, customer: customer)

      get "/api/v1/merchants/#{merchant.id}/invoices"

      invoices = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoices["data"].count).to eq(3)
    end
  end

  describe "business logic" do
    before :each do
      @merchant = create(:merchant)
    end
    it "returns customer with the most successful transactions" do
      customer_1 = create(:customer, id: "1")
      customer_2 = create(:customer, id: "2")
      customer_3 = create(:customer, id: "3")

      c1_invoice = create(:invoice, customer: customer_1, merchant: @merchant)
      c2_invoice = create(:invoice, customer: customer_2, merchant: @merchant)
      c3_invoice = create(:invoice, customer: customer_3, merchant: @merchant)

      transactions_c1 = create_list(:transaction, 4, invoice: c1_invoice, result: "success")
      transactions_c2 = create_list(:transaction, 2, invoice: c2_invoice, result: "success")
      transactions_c3 = create_list(:transaction, 5, invoice: c3_invoice, result: "success")

      get "/api/v1/merchants/#{@merchant.id}/favorite_customer"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["data"]["id"]).to eq("3")
    end

    it "returns total revenue for a merchant from successful transactions" do
      customer = create(:customer)
      invoice_1 = create(:invoice, customer: customer, merchant: @merchant)
      invoice_2 = create(:invoice, customer: customer, merchant: @merchant)
      invoice_3 = create(:invoice, customer: customer, merchant: @merchant)

      item_1 = create(:item, merchant: @merchant)
      item_2 = create(:item, merchant: @merchant)
      item_3 = create(:item, merchant: @merchant)

      invoice_item = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 4, unit_price: 13635)
      invoice_item = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2, unit_price: 79140)
      invoice_item = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 5, unit_price: 76941)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

      get "/api/v1/merchants/#{@merchant.id}/revenue"

      revenue = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "returns total revenue for a merchant from successful transactions by a given date" do
      customer = create(:customer)
      invoice_1 = create(:invoice, customer: customer, merchant: @merchant, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_2 = create(:invoice, customer: customer, merchant: @merchant)
      invoice_3 = create(:invoice, customer: customer, merchant: @merchant)

      item_1 = create(:item, merchant: @merchant)
      item_2 = create(:item, merchant: @merchant)
      item_3 = create(:item, merchant: @merchant)

      invoice_item = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 4, unit_price: 13635)
      invoice_item = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2, unit_price: 79140)
      invoice_item = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 5, unit_price: 76941)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

      get "/api/v1/merchants/#{@merchant.id}/revenue?date=2012-03-16"

      revenue = JSON.parse(response.body)

      expect(response).to be_successful
    end


    it "loads total revenue for a date across all merchants" do
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      customer = create(:customer)
      invoice_1 = create(:invoice, customer: customer, merchant: @merchant, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_2 = create(:invoice, customer: customer, merchant: merchant_2, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_3 = create(:invoice, customer: customer, merchant: merchant_3, updated_at: "2012-03-16 10:54:11 UTC")

      item_1 = create(:item, merchant: @merchant)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)

      invoice_item = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 4, unit_price: 13635)
      invoice_item = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2, unit_price: 79140)
      invoice_item = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 5, unit_price: 76941)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "success")


      get "/api/v1/merchants/revenue?date=2012-03-16"

      total_revenue = JSON.parse(response.body)
      expect(response).to be_successful
    end

    it "loads merchants ranked by total revenue and returns a given number" do
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      customer = create(:customer)
      invoice_1 = create(:invoice, customer: customer, merchant: @merchant, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_2 = create(:invoice, customer: customer, merchant: merchant_2, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_3 = create(:invoice, customer: customer, merchant: merchant_3, updated_at: "2012-03-16 10:54:11 UTC")

      item_1 = create(:item, merchant: @merchant)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)

      invoice_item = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 4, unit_price: 13635)
      invoice_item = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2, unit_price: 79140)
      invoice_item = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 5, unit_price: 76941)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

      get "/api/v1/merchants/most_revenue?quantity=3"

      sort_m_by_rev = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "loads merchants ranked by total items sold" do
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      customer = create(:customer)
      invoice_1 = create(:invoice, customer: customer, merchant: @merchant, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_2 = create(:invoice, customer: customer, merchant: merchant_2, updated_at: "2012-03-16 10:54:11 UTC")
      invoice_3 = create(:invoice, customer: customer, merchant: merchant_3, updated_at: "2012-03-16 10:54:11 UTC")

      item_1 = create(:item, merchant: @merchant)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)

      invoice_item = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 4, unit_price: 13635)
      invoice_item = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2, unit_price: 79140)
      invoice_item = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 5, unit_price: 76941)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

      get "/api/v1/merchants/most_items?quantity=3"

      merchants = JSON.parse(response.body)

      expect(response).to be_successful
    end


    it "returns customers with pending invoices associated with one merchant" do
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, merchant: @merchant)
      invoice_2 = create(:invoice, customer: customer_2, merchant: @merchant)
      invoice_3 = create(:invoice, customer: customer_3, merchant: @merchant)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_4 = create(:transaction, invoice: invoice_2, result: "failed")
      transaction_5 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_6 = create(:transaction, invoice: invoice_2, result: "failed")
      transaction_7 = create(:transaction, invoice: invoice_3, result: "failed")
      transaction_8 = create(:transaction, invoice: invoice_3, result: "failed")
      transaction_9 = create(:transaction, invoice: invoice_3, result: "failed")

      get "/api/v1/merchants/#{@merchant.id}/customers_with_pending_invoices"

      customers = JSON.parse(response.body)
      expect(response).to be_successful
    end
  end
end
