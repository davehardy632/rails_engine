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
end
