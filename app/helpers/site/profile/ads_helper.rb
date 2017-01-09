module Site::Profile::AdsHelper
  def get_options_for_category
    Category.all
  end
end
