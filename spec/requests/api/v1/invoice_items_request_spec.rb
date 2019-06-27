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
    expect(invoice_items["data"].count).to eq(3)
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
    expect(invoice_item["data"]["id"].to_i).to eq(id)
  end

  it "loads associated items" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    get "/api/v1/invoice_items/#{invoice_item.id}/item"

    ending_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(ending_item["data"]["attributes"]["id"]).to eq(item.id)
    expect(ending_item["data"]["attributes"]["name"]).to eq(item.name)
  end

  it "loads associated invoice" do
    merchant = create(:merchant)
    customer = create(:customer)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

    ending_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(ending_invoice["data"]["attributes"]["id"]).to eq(invoice.id)
    expect(ending_invoice["data"]["attributes"]["customer_id"]).to eq(customer.id)
  end
end
