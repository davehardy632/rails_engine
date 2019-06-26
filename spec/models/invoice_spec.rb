require 'rails_helper'

RSpec.describe Invoice, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "validations" do
    it {should validate_presence_of :status}
  end

  describe "relationships" do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
  end
end
