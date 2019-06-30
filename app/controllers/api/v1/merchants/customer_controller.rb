class Api::V1::Merchants::CustomerController < ApplicationController

  def show
    render json: CustomerSerializer.new(Customer.merchant_favorite(params[:id]))
  end

  def index
    render json: CustomerSerializer.new(Customer.with_pending_invoices(customer_params))
  end

  private

  def customer_params
    params.permit(:id)
  end
end
