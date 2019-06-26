class Api::V1::MerchantsController < ApplicationController

  def index
    render status: 200, json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end
