require 'rails_helper'

RSpec.describe Merchant, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "validations" do
    it { should validate_presence_of :name}
  end

  describe "relationships" do
    it { should have_many :invoices}
    it {should have_many :items}
  end
end
