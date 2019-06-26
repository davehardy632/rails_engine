class Api::V1::Merchants::FindController < ApplicationController

  def index
    key = params.keys.first
    value = params.values.first
    render status: 200, json: MerchantSerializer.new(Merchant.where(key => value))
  end

  def show
    render status: 200, json: MerchantSerializer.new(Merchant.find_by(merchant_params))
  end

  private

  def merchant_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
