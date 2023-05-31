class CreateTaskService
  class << self
    def perform(user, task_params)
      task = Task.new(task_params)

      unless user.is_a?(ProjectManager)
        task.errors.add(:base, "can only be created by a Project Manager")
        return task
      end


      if ["working", "needs_review"].include?(task.status)
        task.errors.add(:base, "can only be set to this status by an Employee")
        return task
      end

      task.project_manager = user

      if task_params[:assigned_employee_ids].present?
        incoming_ids = task_params[:assigned_employee_ids].map(&:to_i)
        existing_employee_ids = Employee.where(id: incoming_ids).pluck(:id).sort

        if incoming_ids == existing_employee_ids
          ActiveRecord::Base.transaction do
            task.save

            unless task.errors.any?
              incoming_ids.each do |id|
                EmployeeTaskAssignment.create(task: task, employee_id: id)
              end
            end
          end
        else
          incoming_ids.difference(existing_employee_ids).each do |non_existent_employee|
            task.errors.add(:base, "can't be added to non-existent employee #{non_existent_employee}")
          end
          return task
        end
      else
        task.save
      end

      task
    end
  end
end
