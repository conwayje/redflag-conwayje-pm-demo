require 'rails_helper'

RSpec.describe ProjectManager, type: :model do
  before :all do
    @project = Project.create(title: "a", description: "b", due_date: Time.now + 3.days)
    @pm = ProjectManager.create(email: "example1@example.com",
      name: "Example",
      password: "password",
      password_confirmation: "password")
  end

  it "has many tasks" do
    ids = []
    1.upto(3).each do |i|
      t = Task.create(title: "#{i}", project_id: @project.id, project_manager_id: @pm.id)
      ids << t.id
    end

    expect(@pm.tasks.pluck(:id).sort).to eq(ids.sort)
  end
end
