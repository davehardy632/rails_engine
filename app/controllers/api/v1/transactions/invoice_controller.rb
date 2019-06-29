class Api::V1::Transactions::InvoiceController < ApplicationController

  def show
    render json: InvoiceSerializer.new(Invoice.associated_transacton(params[:id]))
  end

end
