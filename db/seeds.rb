1.upto(5).each do |i|
  ProjectManager.create(
    email: "pm#{i}@example.com",
    password: "password",
    password_confirmation: "password",
    name: "Project#{i} Manager#{i}"
  )
end

1.upto(10).each do |i|
  Employee.create(
    email: "employee#{i}@example.com",
    name: "Example#{i} Employee#{i}",
    title: "Level #{(i % 3) + 1} Employee",
    work_focus: i % 4,
    password: "password",
    password_confirmation: "password"
  )
end

1.upto(3).each do |i|
  Project.create(
    title: "Project #{i}",
    description: "Description for project #{i}",
    due_date: Time.now + 7.days
  )
end

1.upto(10).each do |i|
  parent_task_id = i > 6 ? Task.first(3)[i % 3].id : nil

  project_id = if parent_task_id
    Task.find(parent_task_id).project_id
  else
    Project.all.sample.id
  end

  t = Task.create(
    title: "Task #{i}",
    description: "Description for task #{i}",
    work_focus: i % 4,
    due_date: Time.now + 7.days,
    status: 0,
    project_manager_id: ProjectManager.pluck(:id).sample,
    parent_task_id: parent_task_id,
    project_id: project_id
  )
end

Task.all.each do |task|
  employees = Employee.all.sample(3)
  employees.each do |employee|
    EmployeeTaskAssignment.create(
      task: task,
      employee: employee
    )
  end
end



