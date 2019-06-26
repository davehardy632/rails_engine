class Api::V1::Customers::TransactionController < ApplicationController

  def index
    customer = Customer.find(params[:id])
    customer.invoices.joins(:transactions).select("transactions.*")

    render json: TransactionSerializer.new(customer.invoices.joins(:transactions).select("transactions.*"))

  end

end
