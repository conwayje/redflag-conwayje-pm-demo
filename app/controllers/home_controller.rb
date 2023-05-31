class HomeController < ApplicationController
  def index
    @employee = current_employee
    @project_manager = current_project_manager
  end
end
