class Site::SearchController < SiteController

  def ads
    @ads = Ad.search(params[:q], params[:page])
    @categories  = Category.order_by_description
  end
end
