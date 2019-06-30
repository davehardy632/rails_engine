class Api::V1::Items::DateController < ApplicationController

  def show
    render json: DateSerializer.new(Item.best_day(item_params))
  end

  private

  def item_params
    params.permit(:id)
  end

end
