class AddRememberDigestToUsers < ActiveRecord::Migration
  def change # will add an encrypted fixed session for an user so cookies can be safely implemented.
    add_column :users, :remember_digest, :string
  end
end
