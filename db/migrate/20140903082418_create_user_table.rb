class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "username", :limit => 16, :null => false
      t.string "password_digest", :null => false
      t.boolean "admin", :default => false
      t.string "email", :limit => 28, :null => false
      t.boolean "email_confirmed", :default => false
      t.string "first_name", :limit => 16, :null => false
      t.string "mid_name", :limit => 16, :null => false
      t.string "last_name", :limit => 16, :null => false
      t.date "birth", :null => false
      t.timestamps
    end
  end
end
