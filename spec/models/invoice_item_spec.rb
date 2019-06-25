require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Validations" do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
  end

  describe "Relationships" do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end
end
