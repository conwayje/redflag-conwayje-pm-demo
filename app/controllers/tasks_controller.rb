class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ edit update destroy ]
  before_action :project_manager_only, only: %i[ new create destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.includes(:subtasks).all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    @task = Task.includes(:employees).includes(:subtasks).find(params[:id])
  end

  # GET /tasks/new
  def new
    @task = Task.new
    gather_form_variables
  end

  # GET /tasks/1/edit
  def edit
    gather_form_variables
  end

  # POST /tasks or /tasks.json
  def create
    @task = CreateTaskService.perform(current_user, task_params)

    respond_to do |format|
      if @task.errors.any?
        gather_form_variables
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task = UpdateTaskService.perform(@task, current_user, task_params)

    respond_to do |format|
      if @task.errors.any?
        gather_form_variables
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def gather_form_variables
      @valid_parent_options = @task.valid_parent_options
      @work_focus_options = @task.work_focus_options
      @status_options = @task.status_options
      @project_options = @task.project_options
      @assigned_employee_ids_options = @task.assigned_employee_ids_options
      @assigned_employee_ids = @task.employee_ids
    end

    def project_manager_only
      respond_to do |format|
        unless current_project_manager.present?
          format.html { redirect_to :tasks, alert: "Must be project manager" }
          format.json { render json: { "error": "Must be project manager" }, status: :unauthorized }
        else
          format.html { }
          format.json { }
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :work_focus, :due_date, :status,
        :parent_task_id, :project_id, assigned_employee_ids: [])
    end
end
