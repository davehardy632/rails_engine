class Api::V1::Invoices::CustomerController < ApplicationController

  def show
    render json: CustomerSerializer.new(Customer.associated_invoice(params[:id]))
  end

end
