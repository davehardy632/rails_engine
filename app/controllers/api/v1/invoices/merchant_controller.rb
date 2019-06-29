class Api::V1::Invoices::MerchantController < ApplicationController

  def show
    render json: MerchantSerializer.new(Merchant.associated_invoice(params[:id]))
  end

end
