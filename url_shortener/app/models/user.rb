# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true

  def too_many_submissions?
    self.submitted_urls.where(
    "shortened_urls.created_at > ? ", 10.minutes.ago).count > 5
  end

  has_many :submitted_urls,
    class_name: "ShortenedUrl",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :visitor_id,
    primary_key: :id

  has_many :visited_urls,
    Proc.new { distict },
    through: :visits,
    source: :url

  has_many :taggings,
    class_name: "Tagging",
    foreign_key: :tagging_user_id,
    primary_key: :id
end
