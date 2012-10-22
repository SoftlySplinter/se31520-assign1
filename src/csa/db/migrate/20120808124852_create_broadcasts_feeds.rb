class CreateBroadcastsFeeds < ActiveRecord::Migration
	def change
		create_table "broadcasts_feeds", id: false, force: true do |t|
			t.integer :broadcast_id, null: :no
			t.integer :feed_id, null: :no
		end
	end
end
