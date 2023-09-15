class CreateBudgetsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :budget_users do |t|
      t.belongs_to :budget
      t.belongs_to :user
    end
  end
end
