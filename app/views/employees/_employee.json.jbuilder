json.extract! employee, :id, :email, :name, :title, :work_focus, :task_ids, :created_at, :updated_at
json.url employee_url(employee, format: :json)
