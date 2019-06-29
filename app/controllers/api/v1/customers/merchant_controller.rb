class Api::V1::Customers::MerchantController < ApplicationController

  def show
    render json: MerchantSerializer.new(Merchant.customer_favorite(merchant_params))
  end

  private

  def merchant_params
    params.permit(:id, :name)
  end


end
