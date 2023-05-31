class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :work_focus
      t.datetime :due_date
      t.integer :status
      t.references :project_manager, null: false, foreign_key: true

      t.timestamps
    end
  end
end
