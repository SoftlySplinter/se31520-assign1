class CreateUserDetails < ActiveRecord::Migration
  def change
  	  create_table :user_details do |t|
  	  	  t.string :login, limit: 40
		  t.string :salt, limit: 40
		  t.string :crypted_password, limit: 40
		  t.integer :user_id
	  end
  end

end
