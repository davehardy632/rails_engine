class Api::V1::Items::SearchController < ApplicationController

  def show
    key = params.keys.first
    value = params.values.first
    render json: ItemSerializer.new(Item.first_instance_by_attribute(key, value))
  end

  def index
    key = params.keys.first
    value = params.values.first
    render json: ItemSerializer.new(Item.find_all_by_attribute(key, value))
  end

end
