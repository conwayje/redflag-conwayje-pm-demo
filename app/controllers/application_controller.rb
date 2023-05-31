class ApplicationController < ActionController::Base
  devise_group :user, contains: [:project_manager, :employee]

  def after_sign_out_path_for(resource_or_scope)
    "/"
  end
end
