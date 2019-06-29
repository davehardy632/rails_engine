require 'rails_helper'

describe "Transactions Api" do
  it "sends a list of items" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    create_list(:transaction, 3, invoice: invoice)

    get '/api/v1/transactions.json'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)
    expect(transactions["data"].count).to eq(3)
  end

    it "sends a single merchant resource" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    id = create(:transaction, invoice: invoice).id

    get "/api/v1/transactions/#{id}.json"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"].to_i).to eq(id)
  end

  it "loads the associated invoice" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, merchant: merchant, customer: customer )
    transaction = create(:transaction, invoice: invoice)

    get "/api/v1/transactions/#{transaction.id}/invoice"

    end_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(end_invoice["data"]["attributes"]["id"]).to eq(invoice.id)
    expect(end_invoice["data"]["attributes"]["customer_id"]).to eq(customer.id)
    expect(end_invoice["data"]["attributes"]["merchant_id"]).to eq(merchant.id)
  end

  describe "finds first instance by attribute" do
    it "finds instance by id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice = create(:invoice, merchant: merchant, customer: customer )
      transaction = create(:transaction, invoice: invoice)

      get "/api/v1/transactions/find?id=#{transaction.id}"

      end_transaction = JSON.parse(response.body)

      expect(response).to be_successful
    end
  end

  describe "finds all instances by attribute" do
    it "finds all instances by id" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice = create(:invoice, merchant: merchant, customer: customer )
      transaction = create(:transaction, invoice: invoice)

      get "/api/v1/transactions/find_all?id=#{transaction.id}"

      end_transaction = JSON.parse(response.body)

      expect(response).to be_successful
    end
  end
end
