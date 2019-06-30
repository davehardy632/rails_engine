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

    describe "Items business logic" do
      it "loads the best day for a single item" do
        merchant = create(:merchant)
        customer = create(:customer)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)
        item_3 = create(:item, merchant: merchant)

        invoice_1 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-23 16:54:11 UTC" )
        invoice_2 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-16 10:54:11 UTC")
        invoice_3 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-16 10:54:11 UTC")

        invoice_item_1 = create(:invoice_item, quantity: 10, invoice: invoice_1, item: item_1)
        invoice_item_2 = create(:invoice_item, quantity: 9, invoice: invoice_2, item: item_2)
        invoice_item_3 = create(:invoice_item, quantity: 8, invoice: invoice_3, item: item_3)

        transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
        transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
        transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

        get "/api/v1/items/#{item_1.id}/best_day"

        day = JSON.parse(response.body)

        expect(response).to be_successful
        expect(day["data"]["attributes"]["best_day"]).to eq("2012-03-23")
      end

      it "loads the top items by number sold with a given number" do
        merchant = create(:merchant)
        customer = create(:customer)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)
        item_3 = create(:item, merchant: merchant)

        invoice_1 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-23 16:54:11 UTC" )
        invoice_2 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-16 10:54:11 UTC")
        invoice_3 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-16 10:54:11 UTC")

        invoice_item_1 = create(:invoice_item, quantity: 10, invoice: invoice_1, item: item_1)
        invoice_item_2 = create(:invoice_item, quantity: 9, invoice: invoice_2, item: item_2)
        invoice_item_3 = create(:invoice_item, quantity: 8, invoice: invoice_3, item: item_3)

        transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
        transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
        transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

        get "/api/v1/items/most_items?quantity=3"

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].first["id"].to_i).to eq(item_1.id)
      end


      it "loads the top items by total revenue with a given number" do
        merchant = create(:merchant)
        customer = create(:customer)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)
        item_3 = create(:item, merchant: merchant)

        invoice_1 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-23 16:54:11 UTC" )
        invoice_2 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-16 10:54:11 UTC")
        invoice_3 = create(:invoice, customer: customer, merchant: merchant, updated_at: "2012-03-16 10:54:11 UTC")

        invoice_item_1 = create(:invoice_item, quantity: 10, unit_price: "274.09", invoice: invoice_1, item: item_1)
        invoice_item_2 = create(:invoice_item, quantity: 9, unit_price: "274.09", invoice: invoice_2, item: item_2)
        invoice_item_3 = create(:invoice_item, quantity: 8, unit_price: "274.09", invoice: invoice_3, item: item_3)

        transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
        transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
        transaction_3 = create(:transaction, invoice: invoice_3, result: "success")

        get "/api/v1/items/most_revenue?quantity=3"

        items = JSON.parse(response.body)

        expect(response).to be_successful
        expect(items["data"].first["id"].to_i).to eq(item_1.id)
      end
    end
  end
end
