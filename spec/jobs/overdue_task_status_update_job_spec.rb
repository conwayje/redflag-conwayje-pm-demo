require 'rails_helper'

RSpec.describe OverdueTaskStatusUpdateJob, type: :job do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create(email: "example50@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
  end

  it "updates task if, and only if, overdue" do
    t1 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now - 3.days)
    t2 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now - 2.days)
    t3 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now - 1.days)
    t4 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now - 2.seconds)
    t5 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now + 2.seconds)
    t6 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now + 1.days)
    t7 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now + 2.days)
    t8 = Task.create(project: @project, project_manager: @pm, status: "not_started", due_date: Time.now + 3.days)

    expect(Task.where(status: "late").count).to eq 0
    OverdueTaskStatusUpdateJob.perform_inline
    expect(Task.where(status: "late").count).to eq 4
    expect(Task.where(status: "late").pluck(:id).sort).to eq [t1, t2, t3, t4].map(&:id)
  end
end
