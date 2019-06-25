require 'rails_helper'

describe "Invoices Api" do
  it "sends a list of invoices" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice_1 = create(:invoice, merchant: merchant, customer: customer)
    invoice_2 = create(:invoice, merchant: merchant, customer: customer)
    invoice_3 = create(:invoice, merchant: merchant, customer: customer)

    get '/api/v1/invoices.json'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)
    expect(invoices["data"].count).to eq(3)
  end

  it "sends a single merchant resource" do
    customer = create(:customer)
    merchant = create(:merchant)
    id = create(:invoice, merchant: merchant, customer: customer).id

    get "/api/v1/invoices/#{id}.json"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"].to_i).to eq(id)
  end
end
