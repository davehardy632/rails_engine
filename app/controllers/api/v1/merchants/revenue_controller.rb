class Api::V1::Merchants::RevenueController < ApplicationController

  def show
    render json: RevenueSerializer.new(Merchant.find(params[:id]))
  end
end
