class Api::V1::Invoices::SearchController < ApplicationController

  def show
    key = params.keys.first
    value = params.values.first
    render json: InvoiceSerializer.new(Invoice.first_instance_by_attribute(key, value))
  end

  def index
    key = params.keys.first
    value = params.values.first
    render json: InvoiceSerializer.new(Invoice.find_all_by_attribute(key, value))
  end

end
