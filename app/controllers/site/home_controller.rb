class Site::HomeController < ApplicationController
  layout "site"

  def index
    @categories  = Category.order_by_description
    @ads = Ad.descending_order(params[:page])
  end
end
