class Employees::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_project_manager!
  before_action :project_manager_only, only: [:new, :create]

  private

  def project_manager_only
      respond_to do |format|
        unless current_project_manager.present?
          format.html { redirect_back(fallback_location: "/", alert: "Must be project manager") }
          format.json { render json: { "error": "Must be project manager" }, status: :unauthorized }
        else
          format.html { }
          format.json { }
        end
      end
    end
end
