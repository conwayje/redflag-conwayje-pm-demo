class Employee < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :work_focus, { development: 0, design: 1, business: 2, research: 3 }

  has_many :employee_task_assignments, dependent: :destroy
  has_many :tasks, through: :employee_task_assignments

  def assigned_to_task?(task)
    tasks.include?(task)
  end

  def work_focus_options
    self.class.work_focus.map{ |k, v| [k.humanize, k] }
  end
end
