class AddIndexOnTagAndUserToTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, [:tag_topic_id, :short_url_id, :tagging_user_id],
      unique: true, name: 'taggings_index'
  end
end
