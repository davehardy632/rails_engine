require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe "relationships" do
    it { should have_many :invoices}
    it { should have_many(:merchants).through(:invoices)}
  end

  describe "class methods" do
    it "merchant favorite" do
      @merchant = create(:merchant)
      customer_1 = create(:customer, id: "1")
      customer_2 = create(:customer, id: "2")
      customer_3 = create(:customer, id: "3")

      c1_invoice = create(:invoice, customer: customer_1, merchant: @merchant)
      c2_invoice = create(:invoice, customer: customer_2, merchant: @merchant)
      c3_invoice = create(:invoice, customer: customer_3, merchant: @merchant)

      transactions_c1 = create_list(:transaction, 4, invoice: c1_invoice, result: "success")
      transactions_c2 = create_list(:transaction, 2, invoice: c2_invoice, result: "success")
      transactions_c3 = create_list(:transaction, 5, invoice: c3_invoice, result: "success")

      expect(Customer.merchant_favorite(@merchant.id)).to eq(customer_3)
    end

    it "associated_invoice" do
      customer = create(:customer)
      merchant = create(:merchant)
      invoice = create(:invoice, customer: customer, merchant: merchant)

      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)

      ii_1 = create(:invoice_item, item: item_1, invoice: invoice)
      ii_2 = create(:invoice_item, item: item_2, invoice: invoice)
      ii_3 = create(:invoice_item, item: item_3, invoice: invoice)

      expect(Customer.associated_invoice(invoice.id)).to eq(customer)
    end
  end
end
