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

class ShortenedUrl < ActiveRecord::Base
  validates :submitter_id, :presence => true
  validates :short_url, :presence => true, :uniqueness => true

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

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    through: :visits,
    source: :visitor
end
