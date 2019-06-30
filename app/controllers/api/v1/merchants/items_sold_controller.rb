class Api::V1::Merchants::ItemsSoldController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.top_ranked_by_items(merchant_params))
  end

  private

  def merchant_params
    params.permit(:quantity)
  end

end
