class Api::V1::Invoices::TransactionsController < ApplicationController

  def show
    render json: TransactionSerializer.new(Transaction.return_invoices(params[:id]))
  end

end
