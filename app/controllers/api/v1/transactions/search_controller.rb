class Api::V1::Transactions::SearchController < ApplicationController

  def show
    key = params.keys.first
    value = params.values.first
    render json: TransactionSerializer.new(Transaction.first_instance_by_attribute(key, value))
  end

  def index
    key = params.keys.first
    value = params.values.first
    render json: TransactionSerializer.new(Transaction.find_all_by_attribute(key, value))
  end

end
