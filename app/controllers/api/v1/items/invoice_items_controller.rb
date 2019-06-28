class Api::V1::Items::InvoiceItemsController < ApplicationController

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.associated_item(params[:id]))
  end

end
