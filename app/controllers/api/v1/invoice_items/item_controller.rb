class Api::V1::InvoiceItems::ItemController < ApplicationController

  def show
    render json: ItemSerializer.new(Item.by_invoice_item(params[:id]))
  end



end
