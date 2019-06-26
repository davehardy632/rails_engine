class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices
  has_many :customers, through: :invoices
  has_many :items

  # attr_reader :name, :created_at, :updated_at
  #
  # def initialize(name)
  #   @name = name
  #   @created_at = created_at
  #   @updated_at = updated_at
  # end



end
