class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    items = Item.where(merchant_id: params[:id])
    binding.pry
    render status: 200, json: ItemSerializer.new(items)
  end


end
