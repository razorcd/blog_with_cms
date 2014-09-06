class AddEmailConfirmationRandomId < ActiveRecord::Migration
  def change
    add_column(:users, :email_confirmation_id, "string", :null => false)
  end
end
