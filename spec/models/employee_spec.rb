require 'rails_helper'

RSpec.describe Employee, type: :model do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create(email: "example30@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
    @employee = Employee.create(email: "example31@example.com",
      password: "password", password_confirmation: "password")
  end

  it "can have many employee_task_assignments" do
    t1 = Task.create(project: @project, project_manager: @pm)
    t2 = Task.create(project: @project, project_manager: @pm)
    eta1 = EmployeeTaskAssignment.create(task: t1, employee: @employee)
    eta2 = EmployeeTaskAssignment.create(task: t2, employee: @employee)
    expect(@employee.employee_task_assignments.sort).to eq [eta1, eta2]
  end

  it "can have many tasks" do
    t1 = Task.create(project: @project, project_manager: @pm)
    t2 = Task.create(project: @project, project_manager: @pm)
    eta1 = EmployeeTaskAssignment.create(task: t1, employee: @employee)
    eta2 = EmployeeTaskAssignment.create(task: t2, employee: @employee)
    expect(@employee.tasks.sort).to eq [t1, t2]
  end

  describe "#assigned_to_task?" do
    it "returns true when assigned" do
      t = Task.create!(project: @project, project_manager: @pm)
      eta = EmployeeTaskAssignment.create!(task: t, employee: @employee)
      expect(@employee.reload.assigned_to_task?(t)).to eq true
    end

    it "returns false when not assigned" do
      t = Task.create(project: @project, project_manager: @pm)
      expect(@employee.reload.assigned_to_task?(t)).to eq false
    end
  end

  describe "#work_focus_options" do
    it "returns correct list" do
      puts "#{@employee.work_focus_options}"
      expect(@employee.work_focus_options).to eq(
        [["Development", "development"], ["Design", "design"], ["Business", "business"], ["Research", "research"]]
      )
    end
  end
end
