class Api::V1::InvoiceItems::InvoiceController < ApplicationController

  def show
    render json: InvoiceSerializer.new(Invoice.by_invoice_item(params[:id]))
  end

end
