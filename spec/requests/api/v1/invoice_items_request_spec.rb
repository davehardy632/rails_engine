require 'rails_helper'

describe "Invoice Items Api" do
  it "sends a list of invoice items" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    customer = create(:customer)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    create_list(:invoice_item, 3, item: item, invoice: invoice)

    get '/api/v1/invoice_items.json'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)
    expect(invoice_items.count).to eq(3)
  end

  it "sends a single merchant resource" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    customer = create(:customer)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    id = create(:invoice_item, item: item, invoice: invoice).id

    get "/api/v1/invoice_items/#{id}.json"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["id"]).to eq(id)
  end
end
