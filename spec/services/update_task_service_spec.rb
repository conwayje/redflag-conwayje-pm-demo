require 'rails_helper'

RSpec.describe UpdateTaskService, type: :service do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create(email: "example40@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
    @employee = Employee.create(email: "example41@example.com",
      password: "password", password_confirmation: "password")
    @task = Task.create(project: @project, project_manager: @pm, status: "not_started")
  end

  describe "#handle_status_update" do
    it "works for no changes" do
      result = UpdateTaskService.perform(@task, @employee, {})
      expect(result.errors.any?).to eq false
    end
    it "returns errors for employees setting to done" do
      result = UpdateTaskService.perform(@task, @employee, {status: "done"})
      expect(result.errors.first.message).to eq(
        "You can't set a task to this status."
      )
    end
    it "returns errors for employees setting to late" do
      result = UpdateTaskService.perform(@task, @employee, {status: "late"})
      expect(result.errors.first.message).to eq(
        "You can't set a task to this status."
      )
    end
    it "returns errors for project managers setting to working" do
      result = UpdateTaskService.perform(@task, @pm, {status: "working"})
      expect(result.errors.first.message).to eq(
        "You can't set a task to this status."
      )
    end
    it "returns errors for project managers setting to needs_review" do
      result = UpdateTaskService.perform(@task, @pm, {status: "needs_review"})
      expect(result.errors.first.message).to eq(
        "You can't set a task to this status."
      )
    end
    it "returns updated task for employees setting to working / needs_review" do
      @task.update(status: "not_started")
      e = Employee.create(email: "example42@example.com",
        password: "password", password_confirmation: "password")
      eta = EmployeeTaskAssignment.create(employee: e, task: @task)
      result = UpdateTaskService.perform(@task, e, {status: "needs_review"})
      expect(result.errors.any?).to eq false
      expect(result.status).to eq "needs_review"
    end
    it "returns updated task for project managers setting to done / late" do
      @task.update(status: "not_started")
      result = UpdateTaskService.perform(@task, @pm, {status: "done"})
      expect(result.errors.any?).to eq false
      expect(result.status).to eq "done"
    end
  end

  describe "#handle_employee_assignment" do
    it "works for no changes" do
      result = UpdateTaskService.handle_employee_assignment(@task, @pm, {})
      expect(result.errors.any?).to eq false
    end
    it "returns errors when employee tries to change" do
      result = UpdateTaskService.handle_employee_assignment(@task, @employee, {
        assigned_employee_ids: [@employee.id]
      })
      expect(result.errors.first.message).to eq(
        "can only have assignments updated by a project manager"
      )
    end
    it "returns updated task with exact incoming set for project manager" do
      e = Employee.create(email: "example43@example.com",
        password: "password", password_confirmation: "password")
      eta = EmployeeTaskAssignment.create(employee: e, task: @task)

      e2 = Employee.create(email: "example44@example.com",
        password: "password", password_confirmation: "password")
      result = UpdateTaskService.handle_employee_assignment(@task, @pm, {
        assigned_employee_ids: [e2.id]
      })

      expect(result.employees).to eq [e2]
    end
    it "returns error when non-existent employee is added" do
      pm = ProjectManager.create(email: "example45@example.com",
        name: "Example",
        password: "password",
        password_confirmation: "password")
      task = Task.create(project: @project, project_manager: pm, status: "not_started")
      result = UpdateTaskService.handle_employee_assignment(task, pm, {
        assigned_employee_ids: [-1]
      })
      expect(result.errors.first.message).to eq(
        "can't be added to non-existent employee -1"
      )
    end
  end

  describe "#handle_other_changes" do
    it "handles attributes other than status and employee assignments" do
      @task.update(title: "a", description: "a", status: "needs_review")
      result = UpdateTaskService.handle_other_changes(@task, @pm, {
        title: "b", description: "b", status: "done"
      })
      expect(result.title).to eq "b"
      expect(result.description).to eq "b"
      expect(result.status).to eq "needs_review" # ignored by method
    end
  end
end
