class CreateImages < ActiveRecord::Migration
    def self.up
        create_table :images do |t|
           t.integer :user_id
        end
        add_attachment :images, :photo
    end

    def self.down
        remove_attachment :images, :photo
        drop_table :images
    end
end
