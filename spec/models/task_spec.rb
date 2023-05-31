require 'rails_helper'

RSpec.describe Task, type: :model do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create(email: "example2@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
  end
  it "has a project and project manager" do
    t = Task.create(project: @project, project_manager: @pm)
    expect(t.project).to eq @project
    expect(t.project_manager).to eq @pm
  end

  it "can have a blank parent_task" do
    t = Task.create(project: @project, project_manager: @pm)
    expect(t.parent_task_id).to be_nil
  end

  it "can take a parent_task" do
    t = Task.create(project: @project, project_manager: @pm)
    t2 = Task.create(project: @project, project_manager: @pm, parent_task: t)
    expect(t2.parent_task_id).to eq t.id
  end

  it "can have multiple subtasks" do
    t = Task.create(project: @project, project_manager: @pm)
    t2 = Task.create(project: @project, project_manager: @pm, parent_task: t)
    t3 = Task.create(project: @project, project_manager: @pm, parent_task: t)

    expect(t.subtasks.sort).to eq([t2, t3])
  end

  it "can have multiple employee_task_assignments" do
    e1 = Employee.create!(email: "example3@example.com", password: "password",
      password_confirmation: "password")
    e2 = Employee.create!(email: "example4@example.com", password: "password",
      password_confirmation: "password")
    t = Task.create(project: @project, project_manager: @pm)
    eta1 = EmployeeTaskAssignment.create(task: t, employee: e1)
    eta2 = EmployeeTaskAssignment.create(task: t, employee: e2)

    expect(t.employee_task_assignments.count).to eq 2
  end

  it "can have multiple employees" do
    e1 = Employee.create!(email: "example5@example.com", password: "password",
      password_confirmation: "password")
    e2 = Employee.create!(email: "example6@example.com", password: "password",
      password_confirmation: "password")
    t = Task.create(project: @project, project_manager: @pm)
    eta1 = EmployeeTaskAssignment.create(task: t, employee: e1)
    eta2 = EmployeeTaskAssignment.create(task: t, employee: e2)

    expect(t.employees.sort).to eq [e1, e2]
  end

  describe "#employee_ids" do
    it "returns list of integer ids" do
      e1 = Employee.create!(email: "example7@example.com", password: "password",
      password_confirmation: "password")
      e2 = Employee.create!(email: "example8@example.com", password: "password",
        password_confirmation: "password")
      t = Task.create(project: @project, project_manager: @pm)
      eta1 = EmployeeTaskAssignment.create(task: t, employee: e1)
      eta2 = EmployeeTaskAssignment.create(task: t, employee: e2)

      expect(t.employee_ids).to eq [e1.id, e2.id]
    end
  end

  describe "#assigned_to_employee?" do
    it "returns true when assigned" do
      e = Employee.create!(email: "example9@example.com", password: "password",
      password_confirmation: "password")
      t = Task.create(project: @project, project_manager: @pm)
      eta = EmployeeTaskAssignment.create(task: t, employee: e)

      expect(t.assigned_to_employee?(e)).to eq true
    end

    it "returns false when not assigned" do
      e = Employee.create!(email: "example10@example.com", password: "password",
      password_confirmation: "password")
      t = Task.create(project: @project, project_manager: @pm)

      expect(t.assigned_to_employee?(e)).to eq false
    end
  end

  describe "#work_focus_options" do
    it "returns correct list" do
      t = Task.new
      expect(t.work_focus_options).to eq(
        [["Development", "development"], ["Design", "design"], ["Business", "business"], ["Research", "research"]]
      )
    end
  end

  describe "#status_options" do
    it "returns correct list" do
      t = Task.new
      expect(t.status_options).to eq(
        [["Not started", "not_started"], ["Working", "working"], ["Needs review", "needs_review"], ["Done", "done"], ["Late", "late"]]
      )
    end
  end
end
