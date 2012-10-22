class CreateBroadcasts < ActiveRecord::Migration
  def change
  	  # A broadcast record is only created when a broadcast has been successfully
  	  # sent. Note that broadcast feed information associated with this broadcast will
  	  # be in other tables
  	  create_table :broadcasts do |t|
  	  	  t.text :content, null: :no    # Must have some text, empty broadcasts not allowed
  	  	  t.integer :user_id, null: :no # Must have been initiated by someone
  	  	  t.timestamps                     # Created at will double up as bradcast date
  	  end
  end
end
