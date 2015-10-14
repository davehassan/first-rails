class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_topic_id
      t.integer :short_url_id
      t.integer :tagging_user_id

      t.timestamps
    end

    add_index :taggings, :tag_topic_id
  end
end
