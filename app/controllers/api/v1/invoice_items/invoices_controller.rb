class Api::V1::InvoiceItems::InvoicesController < ApplicationController

  def show
    render json: InvoiceSerializer.new(Invoice.invoice_by_invoice_item(params[:id]))
  end
end
