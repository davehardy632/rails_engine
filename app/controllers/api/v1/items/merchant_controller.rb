class  Api::V1::Items::MerchantController < ApplicationController

  def show
    render json: MerchantSerializer.new(Merchant.by_associated_item(params[:id]))
  end
end
