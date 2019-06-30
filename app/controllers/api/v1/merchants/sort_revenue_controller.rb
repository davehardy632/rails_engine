class Api::V1::Merchants::SortRevenueController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.top_ranked(merchant_params))
  end

  private

  def merchant_params
    params.permit(:quantity)
  end

end
