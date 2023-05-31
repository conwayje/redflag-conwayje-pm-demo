json.extract! task, :id, :title, :description, :work_focus, :due_date, :status,
  :project_manager_id, :project_id, :parent_task_id, :assigned_employee_ids, :subtask_ids,
  :created_at, :updated_at
json.url task_url(task, format: :json)
