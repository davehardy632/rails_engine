require 'rails_helper'

describe "Items Api" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 3, merchant: merchant)

    get '/api/v1/items.json'

    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items["data"].count).to eq(3)
  end

  it "sends a single merchant resource" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/#{id}.json"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"].to_i).to eq(id)
  end

  it "loads associated invoice items" do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    invoice_1 = create(:invoice, customer: customer, merchant: merchant)
    invoice_2 = create(:invoice, customer: customer, merchant: merchant)
    invoice_3 = create(:invoice, customer: customer, merchant: merchant)

    ii_1 = create(:invoice_item, invoice: invoice_1, item: item)
    ii_2 = create(:invoice_item, invoice: invoice_2, item: item)
    ii_3 = create(:invoice_item, invoice: invoice_3, item: item)

    get "/api/v1/items/#{item.id}/invoice_items"

    invoice_items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_items["data"].first["attributes"]["item_id"]).to eq(item.id)
  end
end
