json.extract! project, :id, :title, :description, :due_date, :task_ids, :created_at, :updated_at
json.url project_url(project, format: :json)
