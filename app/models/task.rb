class Task < ApplicationRecord
  belongs_to :project_manager
  belongs_to :project

  enum :work_focus, { development: 0, design: 1, business: 2, research: 3 }
  enum :status, { not_started: 0, working: 1, needs_review: 2, done: 3, late: 4 }

  belongs_to :parent_task, class_name: "Task", optional: true
  has_many :subtasks, class_name: "Task", foreign_key: :parent_task_id, dependent: :destroy

  has_many :employee_task_assignments, dependent: :destroy
  has_many :employees, through: :employee_task_assignments

  attr_accessor :assigned_employee_ids

  def employee_ids
    employees.map(&:id)
  end

  def assigned_to_employee?(employee)
    employees.include?(employee)
  end

  def valid_parent_options
    # you can't pick yourself as a parent
    # you can't pick any task which is already a sub-task (i.e. no sub-sub-tasks)
    self.class.where.not(id: self.id).where(parent_task_id: nil).map { |t| [t.title, t.id] }
  end

  def work_focus_options
    self.class.work_focus.map{ |k, v| [k.humanize, k] }
  end

  def status_options
    self.class.statuses.map{ |k, v| [k.humanize, k] }
  end

  def project_options
    Project.all.map{ |p| [p.title, p.id] }
  end

  def assigned_employee_ids_options
    Employee.all.map { |e| [e.name, e.id] }
  end
end
