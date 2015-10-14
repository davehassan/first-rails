# == Schema Information
#
# Table name: taggings
#
#  id              :integer          not null, primary key
#  tag_topic_id    :integer
#  short_url_id    :integer
#  tagging_user_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Tagging < ActiveRecord::Base
  validates :tag_topic_id, :short_url_id, :tagging_user_id, presence: true
  validates :tag_topic_id, uniqueness: { scope: [:short_url_id, :tagging_user_id]}

  belongs_to :topic,
    class_name: "TagTopic",
    foreign_key: :tag_topic_id,
    primary_key: :id

  belongs_to :url,
    class_name: "ShortenedUrl",
    foreign_key: :short_url_id,
    primary_key: :id

  belongs_to :user
    class_name: "User",
    foreign_key: :tagging_user_id,
    primary_key: :id
end
