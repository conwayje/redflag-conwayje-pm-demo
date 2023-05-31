class AddBasicInformationToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :name, :string
    add_column :employees, :title, :string
    add_column :employees, :work_focus, :integer
  end
end
