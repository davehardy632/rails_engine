require 'rails_helper'

describe "Invoice Items API relationships" do
  it "loads individual invoice items" do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    get "/api/v1/invoice_items/#{invoice_item.id}"

    ii = JSON.parse(response.body)
    expect(response).to be_successful
  end

  it "returns associated item" do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    get "/api/v1/invoice_items/#{invoice_item.id}/item"

    item = JSON.parse(response.body)
    expect(response).to be_successful
  end

  it "returns associated invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)
    invoice_item = create(:invoice_item, item: item, invoice: invoice)

    get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

    end_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(end_invoice["data"]["attributes"]["id"]).to eq(invoice.id)
    expect(end_invoice["data"]["attributes"]["customer_id"]).to eq(invoice.customer_id)
  end


  describe "endpoints" do
    it "loads all invoice items" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice)
      invoice_item = create(:invoice_item, item: item, invoice: invoice)
      invoice_item = create(:invoice_item, item: item, invoice: invoice)

      get "/api/v1/invoice_items"

      iis = JSON.parse(response.body)

      expect(response).to be_successful
      expect(iis["data"].count).to eq(3)
    end

    it "finds first instance by id" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice)

      get "/api/v1/invoice_items/find?id=#{invoice_item.id}"

      ii = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "finds first instance by item id" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice)

      get "/api/v1/invoice_items/find?item_id=#{item.id}"

      end_item = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "finds first instance by item id" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice)

      get "/api/v1/invoice_items/find?invoice_id=#{invoice.id}"

      end_invoice = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "finds first instance by quantity" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice, quantity: 100)

      get "/api/v1/invoice_items/find?quantity=#{invoice_item.quantity}"

      end_ii = JSON.parse(response.body)

      expect(response).to be_successful
    end

    it "finds first instance by unit price" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice, quantity: 100, unit_price: 12345)

      get "/api/v1/invoice_items/find?unit_price=#{833.63}"

      end_price = JSON.parse(response.body)

      expect(response).to be_successful
    end
  end
  # for find add extra tests for created at and updated at
  describe "find all instances from attributes" do
    it "find all by id" do
      customer = create(:customer)
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)
      invoice_item = create(:invoice_item, item: item, invoice: invoice, quantity: 100, unit_price: 12345)

      get "/api/v1/invoice_items/find_all?id=#{invoice_item.id}"
      ii = JSON.parse(response.body)

      expect(response).to be_successful
      # expect(ii["data"].first["attributes"])
    end
  end
end
