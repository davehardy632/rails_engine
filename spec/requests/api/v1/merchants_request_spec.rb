require 'rails_helper'

describe "Merchants Api" do
  it "sends a list of items" do
    create_list(:merchant, 3)

    get '/api/v1/merchants.json'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(3)
  end

  it "sends a single merchant resource" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}.json"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"].to_i).to eq(id)
  end

  describe "sends a resource based on a merchant attribute" do
    it "sends a resource based on merchant name" do
      starting_merchant = create(:merchant)

      get "/api/v1/merchants/find?name=#{starting_merchant.name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful

      expect(merchant["data"]["attributes"]["name"]).to eq(starting_merchant.name)
    end

    it "sends a resource based on merchant created at date" do
      starting_merchant = create(:merchant, created_at: "2012-03-27T14:54:05.000Z")

      get "/api/v1/merchants/find?created_at=#{starting_merchant.created_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["id"].to_i).to eq(starting_merchant.id)
    end

    it "sends a resource based on merchant updated_at date" do
      starting_merchant = create(:merchant, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2012-03-30T14:54:05.000Z")

      get "/api/v1/merchants/find?updated_at=#{starting_merchant.updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["id"].to_i).to eq(starting_merchant.id)
    end

    it "sends a random merchant record when random is passed in the url" do
      create_list(:merchant, 3)

      get "/api/v1/merchants/random.json"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["data"]["attributes"]).to include("name")
    end
  end

  describe "Returns all instances by given attributes" do
    it "returns all instances of merchant by id" do
      merchants = create_list(:merchant, 3)

      first_merchant = merchants.first

      get "/api/v1/merchants/find_all?id=#{first_merchant.id}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["id"].to_i).to eq(first_merchant.id)
    end


    it "returns all instances of merchant by name" do
      merchant_1 = create(:merchant, name: "john")
      merchant_2 = create(:merchant, name: "bill")
      merchant_3 = create(:merchant, name: "laura")

      get "/api/v1/merchants/find_all?name=#{merchant_1.name}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["attributes"]["name"]).to eq(merchant_1.name)
    end

    it "returns all instances of merchant by created at date" do
      merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:09.000Z")
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      get "/api/v1/merchants/find_all?created_at=#{merchant_1.created_at}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["attributes"]["name"]).to eq(merchant_1.name)
    end

    it "returns all instances of merchant by created at date" do
      merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:09.000Z", updated_at: "2012-03-27T14:54:09.000Z")
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      get "/api/v1/merchants/find_all?created_at=#{merchant_1.updated_at}"

      same_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(same_merchant["data"].first["attributes"]["name"]).to eq(merchant_1.name)
    end
  end
end
