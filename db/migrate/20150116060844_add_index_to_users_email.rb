class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email ,unique: true #adds unique index to the attribute 'email' for the model 'user'
  end
end
