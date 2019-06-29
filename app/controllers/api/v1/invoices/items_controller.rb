class Api::V1::Invoices::ItemsController < ApplicationController

  def show
    render json: ItemSerializer.new(Item.find_by_invoice_id(params[:id]))
  end
end
