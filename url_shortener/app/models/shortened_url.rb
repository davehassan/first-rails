# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string(255)
#  short_url    :string(255)
#  submitter_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'securerandom'
require 'launchy'

class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, :presence => true
  validates :short_url, presence: true, :uniqueness => true
  validates :long_url, length: { maximum: 255}
  validate :too_many_submissions?

  def self.random_code
    url_code = SecureRandom::urlsafe_base64
    while exists?(:short_url => url_code)
      url_code = SecureRandom::urlsafe_base64
    end

    url_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = random_code

    ShortenedUrl.create!(short_url: short_url,
     long_url: long_url, submitter_id: user.id )
  end

  def too_many_submissions?
    if User.find_by_id(self.submitter_id).too_many_submissions?
      errors.add(:submitter_id, "Too many! What's wrong with you?")
    end
  end

  def num_clicks
    self.visitors.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where("visits.updated_at > ? ",
      10.minutes.ago).count
  end

  def launch
    Launchy.open(self.long_url)
  end

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    Proc.new {distinct},
    through: :visits,
    source: :visitor

  has_many :taggings,
    class_name: "Tagging",
    foreign_key: :short_url_id,
    primary_key: :id

  has_many :tags,
    through: :taggings,
    source: :topic


end
