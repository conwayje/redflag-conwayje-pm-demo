require 'rails_helper'

RSpec.describe Project, type: :model do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create(email: "example20@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
  end

  it "can have many tasks" do
    t1 = Task.create(project: @project, project_manager: @pm)
    t2 = Task.create(project: @project, project_manager: @pm)
    t3 = Task.create(project: @project, project_manager: @pm)
    expect(@project.tasks.sort).to eq [t1, t2, t3]
  end
end
