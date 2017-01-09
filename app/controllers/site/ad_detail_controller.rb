class Site::AdDetailController < ApplicationController
  layout "site"

  def show
    @ad = Ad.find(params[:id])
    @categories  = Category.order_by_description
  end
end
