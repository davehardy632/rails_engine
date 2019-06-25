require 'rails_helper'

describe "Merchants Api" do
  it "sends a list of items" do
    create_list(:merchant, 3)

    get '/api/v1/merchants.json'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants.count).to eq(3)
  end

  it "sends a single item resource" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}.json"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(id)
  end
end
