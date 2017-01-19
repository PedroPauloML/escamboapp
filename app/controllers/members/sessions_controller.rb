class Members::SessionsController < Devise::SessionsController
  protected
    def after_sign_in_path_for(resource)
      stored_location = stored_location_for(resource)

      if stored_location == root_path
        site_profile_dashboard_index_path
      else
        stored_location
      end
    end
end