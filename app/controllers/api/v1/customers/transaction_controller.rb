class Api::V1::Customers::TransactionController < ApplicationController

  def index
    customer = Customer.find(params[:id])
    render json: TransactionSerializer.new(customer.invoices.joins(:transactions).select("transactions.*"))

  end

end
