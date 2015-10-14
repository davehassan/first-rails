class Tagging < ActiveRecord::Base
  validates :tag_topic_id, :short_url_id, :tagging_user_id, presence: true

  
end
