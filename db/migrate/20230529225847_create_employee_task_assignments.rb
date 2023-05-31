class CreateEmployeeTaskAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_task_assignments do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
