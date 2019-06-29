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

  it  "loads a collection of transactions associated with one invoice" do
    customer = create(:customer)
    merchant = create(:merchant)

    invoice = create(:invoice, customer: customer, merchant: merchant)

    transactions = create_list(:transaction, 3, invoice: invoice)


    get "/api/v1/invoices/#{invoice.id}/transactions"

    ending_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    # expect(ending_transactions["data"].first["attributes"]).to eq(invoice.id)
  end

  it  "loads a collection of items associated with one invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)

    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)
    item_3 = create(:item, merchant: merchant)

    ii_1 = create(:invoice_item, item: item_1, invoice: invoice)
    ii_2 = create(:invoice_item, item: item_2, invoice: invoice)
    ii_3 = create(:invoice_item, item: item_3, invoice: invoice)



    get "/api/v1/invoices/#{invoice.id}/items"

    ending_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(ending_items["data"].first["attributes"]["merchant_id"]).to eq(merchant.id)
  end


  it  "loads a collection of invoice items associated with one invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)

    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)
    item_3 = create(:item, merchant: merchant)

    ii_1 = create(:invoice_item, item: item_1, invoice: invoice)
    ii_2 = create(:invoice_item, item: item_2, invoice: invoice)
    ii_3 = create(:invoice_item, item: item_3, invoice: invoice)



    get "/api/v1/invoices/#{invoice.id}/invoice_items"

    ending_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(ending_invoice_items["data"].first["attributes"]["invoice_id"]).to eq(invoice.id)
  end

  it  "returns the associated customer with an invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)

    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)
    item_3 = create(:item, merchant: merchant)

    ii_1 = create(:invoice_item, item: item_1, invoice: invoice)
    ii_2 = create(:invoice_item, item: item_2, invoice: invoice)
    ii_3 = create(:invoice_item, item: item_3, invoice: invoice)



    get "/api/v1/invoices/#{invoice.id}/customer"

    end_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(end_customer["data"]["attributes"]["id"]).to eq(customer.id)
    expect(end_customer["data"]["attributes"]["first_name"]).to eq(customer.first_name)
    expect(end_customer["data"]["attributes"]["last_name"]).to eq(customer.last_name)
  end

  it  "returns the associated merchant with an invoice" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer: customer, merchant: merchant)

    item_1 = create(:item, merchant: merchant)
    item_2 = create(:item, merchant: merchant)
    item_3 = create(:item, merchant: merchant)

    ii_1 = create(:invoice_item, item: item_1, invoice: invoice)
    ii_2 = create(:invoice_item, item: item_2, invoice: invoice)
    ii_3 = create(:invoice_item, item: item_3, invoice: invoice)



    get "/api/v1/invoices/#{invoice.id}/merchant"

    end_merch = JSON.parse(response.body)

    expect(response).to be_successful
    expect(end_merch["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(end_merch["data"]["attributes"]["name"]).to eq(merchant.name)
  end


  describe "find single instance of invoice by attributes" do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice_1 = create(:invoice, customer: customer, merchant: merchant)
    invoice_2 = create(:invoice, customer: customer, merchant: merchant)
    invoice_3 = create(:invoice, customer: customer, merchant: merchant)

    get "/api/v1/invoices/find?id=#{invoice_find['id']}"

    end_invoice = JSON.parse(response.body)

    expect(response).to be_successful
  end
end
