class Api::V1::Items::RevenueController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.ranked_by_revenue(item_params))
  end

  private

  def item_params
    params.permit(:quantity)
  end
end
