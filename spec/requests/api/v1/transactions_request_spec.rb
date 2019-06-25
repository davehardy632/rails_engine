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
    expect(transactions.count).to eq(3)
  end

    it "sends a single merchant resource" do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    id = create(:transaction, invoice: invoice).id

    get "/api/v1/transactions/#{id}.json"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["id"]).to eq(id)
  end
end
