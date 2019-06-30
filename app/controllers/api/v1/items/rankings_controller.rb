class Api::V1::Items::RankingsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.top_by_items_sold(item_params))
  end

  private

  def item_params
    params.permit(:quantity)
  end

end
