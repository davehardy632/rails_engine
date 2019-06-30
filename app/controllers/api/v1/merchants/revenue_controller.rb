class Api::V1::Merchants::RevenueController < ApplicationController

  def show
    if params["date"]
      datetime = params["date"]
      merchant = Merchant.find(params[:id])
      render json: RevenueSerializer.new(merchant.total_revenue(revenue_params))
    else
      merchant = Merchant.find(params[:id])
      render json: RevenueSerializer.new(merchant.total_revenue)
    end
  end

  def index
    render json: TotalRevenueSerializer.new(Merchant.total_revenue_all(revenue_params))
  end

  private

  def revenue_params
    params.permit(:id, :date)
  end
end
