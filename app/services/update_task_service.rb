class UpdateTaskService
  class << self
    def perform(task, user, task_params)
      task = handle_status_update(task, user, task_params)
      task = handle_employee_assignment(task, user, task_params) unless task.errors.any?
      task = handle_other_changes(task, user, task_params) unless task.errors.any?

      task
    end

    def handle_other_changes(task, user, task_params)
      params = task_params.except(:assigned_employee_ids, :status)
      task.update(params)
      task
    end

    def handle_employee_assignment(task, user, task_params)
      return task unless task_params[:assigned_employee_ids].present?
      incoming_ids = task_params[:assigned_employee_ids].map(&:to_i).sort
      existing_employee_ids = Employee.where(id: incoming_ids).pluck(:id).sort
      already_assigned_ids = task.employees.pluck(:id)

      if incoming_ids != already_assigned_ids and !user.is_a?(ProjectManager)
        task.errors.add(:base, "can only have assignments updated by a project manager")
      elsif incoming_ids == existing_employee_ids
        ids_to_create = incoming_ids.difference(already_assigned_ids)
        ActiveRecord::Base.transaction do
          ids_to_create.each do |id|
            EmployeeTaskAssignment.create(task: task, employee_id: id)
          end
          task.employee_task_assignments.where.not(employee_id: incoming_ids).destroy_all
        end
      else
        incoming_ids.difference(existing_employee_ids).each do |non_existent_employee|
          task.errors.add(:base, "can't be added to non-existent employee #{non_existent_employee}")
        end
      end
      task
    end

    def handle_status_update(task, user, task_params)
      status = task.status
      if task_params[:status].present?
        param_status = task_params[:status]
        return task if param_status == status
        if (param_status == "done" and status != "done") or (param_status == "late" and status != "late")
          unless user == task.project_manager
            task.errors.add(:base, "You can't set a task to this status.")
          end
        end

        if (param_status == "working" and status != "working") or (param_status == "needs_review" and status != "needs_review")
          if status != param_status and !task.assigned_to_employee?(user)
            task.errors.add(:base, "You can't set a task to this status.")
          end
        end
        task.status = param_status
      end
      task
    end
  end
end
