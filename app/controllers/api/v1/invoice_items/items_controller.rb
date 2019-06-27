class Api::V1::InvoiceItems::ItemsController < ApplicationController

  # def show
  #   render json: ItemSerializer.new(InvoiceItem.find(params[:id]))
  # end
  def show
    render json: ItemSerializer.new(Item.for_invoice_item(params[:id]))
  end


end
