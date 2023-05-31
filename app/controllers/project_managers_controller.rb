class ProjectManagersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_manager, only: %i[ show edit update destroy ]

  # GET /project_managers or /project_managers.json
  def index
    @project_managers = ProjectManager.all
  end

  # GET /project_managers/1 or /project_managers/1.json
  def show
  end

  def edit
  end

  # PATCH/PUT /project_managers/1 or /project_managers/1.json
  def update
    respond_to do |format|
      if @project_manager.update(project_manager_params)
        format.html { redirect_to project_manager_url(@project_manager), notice: "Project manager was successfully updated." }
        format.json { render :show, status: :ok, location: @project_manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_managers/1 or /project_managers/1.json
  def destroy
    @project_manager.destroy

    respond_to do |format|
      format.html { redirect_to project_managers_url, notice: "Project manager was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_manager
      @project_manager = ProjectManager.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_manager_params
      params.require(:project_manager).permit(:name)
    end
end
