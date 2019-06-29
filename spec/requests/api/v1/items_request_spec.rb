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

  it "loads associated merchant" do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)


    get "/api/v1/items/#{item.id}/merchant"

    end_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(end_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(end_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  describe "search first instances of items by attribute" do
    it "first instance by id" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/find?id=#{item.id}"

      end_item = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "first instance by unit_price" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant, name: "Item Deserunt Dicta", description: "Rem quos non dolores sit. Est facilis error ab adipisci consequuntur quo et. Vel error eos.", unit_price: "274.09", created_at: "2012-03-27T14:54:05.000Z", updated_at: "2012-03-27T14:54:05.000Z")

      get "/api/v1/items/find?unit_price=#{274.09}"

      end_item = JSON.parse(response.body)

      expect(response).to be_successful
    end

  describe "search all instances of items by attribute" do
    it "all instances by id" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get "/api/v1/items/find_all?id=#{item.id}"

      end_item = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "all instances by unit_price" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant, name: "Item Deserunt Dicta", description: "Rem quos non dolores sit. Est facilis error ab adipisci consequuntur quo et. Vel error eos.", unit_price: "274.09", created_at: "2012-03-27T14:54:05.000Z", updated_at: "2012-03-27T14:54:05.000Z")

      get "/api/v1/items/find?unit_price=#{576.32}"

      end_item = JSON.parse(response.body)

      expect(response).to be_successful
      end
    end
  end
end
