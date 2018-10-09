# frozen_string_literal: true

class Offer < ActiveRecord::Base
  before_validation :set_published_at, only: :create
  extend FriendlyId
  friendly_id :title, use: :slugged

  default_scope { order(created_at: :desc) }

  has_many :comments, as: :commentable
  belongs_to :user, counter_cache: true

  validates :title, :description, :published_at, :until, :store, :address, presence: true

  has_attached_file :image,
                    styles: {
                      thumb: "100x100>",
                      medium: "400x225#",
                      large: "400x300>"
                    },
                    default_url: "propias/offer_:style.png"

  validates_attachment :image, 
                       content_type: {
                        content_type: [
                          "image/jpg",
                          "image/jpeg",
                          "image/png","image/gif"
                        ]
                      }

  enum status: %i[available expired]

  private

  def set_published_at
    self.published_at = Time.now
  end
end
