class Api::V1::Invoices::InvoiceItemsController < ApplicationController

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by_invoice(params[:id]))
  end

end
