require 'rails_helper'

RSpec.describe CreateTaskService, type: :service do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create!(email: "example60@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
    @employee = Employee.create(email: "example61@example.com",
      password: "password", password_confirmation: "password")
  end

  it "returns errors for non-project manager" do
    result = CreateTaskService.perform(@employee, {})
    expect(result.errors.first.message).to eq(
      "can only be created by a Project Manager"
    )
  end

  it "returns errors for employee-only statuses" do
    result = CreateTaskService.perform(@pm, {
      status: "needs_review", title: "a", description: "a",
      work_focus: "development", due_date: Time.now + 3.days,
      project_id: @project.id})

    expect(result.errors.first.message).to eq(
      "can only be set to this status by an Employee"
    )
  end

  it "assigns the project manager" do
    result = CreateTaskService.perform(@pm, {
      status: "not_started", title: "a", description: "a",
      work_focus: "development", due_date: Time.now + 3.days,
      project_id: @project.id})
    expect(result.project_manager).to eq @pm
  end

  it "assigns employees" do
    result = CreateTaskService.perform(@pm, {
      status: "not_started", title: "a", description: "a",
      work_focus: "development", due_date: Time.now + 3.days,
      project_id: @project.id, assigned_employee_ids: [@employee.id]})
    expect(result.employees).to eq [@employee]
  end

  it "returns errors for non-existent employees" do
    result = CreateTaskService.perform(@pm, {
      status: "not_started", title: "a", description: "a",
      work_focus: "development", due_date: Time.now + 3.days,
      project_id: @project.id, assigned_employee_ids: [-1]})
    expect(result.errors.first.message).to eq(
      "can't be added to non-existent employee -1"
    )
  end

  it "assigns other attributes" do
    result = CreateTaskService.perform(@pm, {
      status: "not_started", title: "a", description: "a",
      work_focus: "development", due_date: Time.now + 3.days,
      project_id: @project.id, assigned_employee_ids: [@employee.id]})
    expect(result.status).to eq("not_started")
    expect(result.work_focus).to eq("development")
    expect(result.project_id).to eq(@project.id)
  end
end
