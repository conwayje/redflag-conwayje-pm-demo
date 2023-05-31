class AddNameToProjectManagers < ActiveRecord::Migration[7.0]
  def change
    add_column :project_managers, :name, :string
  end
end
