class AddDefaultsToUsersRoleStatus < ActiveRecord::Migration[7.0]
  def change
   
    change_column_default :users, :role, 1
    change_column_default :users, :status, 0

    change_column_null :users, :role, false
    change_column_null :users, :status, false
  end
end
