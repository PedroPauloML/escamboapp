class BackofficeController < ApplicationController

  def pundit_user
    current_admin # current_user to Pundit
  end
  before_action :authenticate_admin!
  layout "backoffice"
end