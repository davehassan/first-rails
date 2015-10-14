class Visit < ActiveRecord::Base
  validates :visitor_id, :shortened_url_id, :presence => true

  def self.record_visit!(user, shortened_url)
    visitor_id = user.id
    shortened_url_id = shortened_url.id

    Visit.create!(visitor_id: visitor_id,
      shortened_url_id: shortened_url_id)
  end

  belongs_to :url,
    class_name: "ShortenedUrl",
    foreign_key: :shortened_url_id,
    primary_key: :id

  belongs_to :visitor,
    class_name: "User",
    foreign_key: :visitor_id,
    primary_key: :id
end
