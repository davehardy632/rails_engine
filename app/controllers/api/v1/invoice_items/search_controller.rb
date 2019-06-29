class Api::V1::InvoiceItems::SearchController < ApplicationController

  def show
    key = params.keys.first
    value = params.values.first
    render json: InvoiceItemSerializer.new(InvoiceItem.first_instance_by_attribute(key, value))
  end

  def index
    key = params.keys.first
    value = params.values.first
    render json: InvoiceItemSerializer.new(InvoiceItem.find_all_by_attribute(key, value))
  end
end
