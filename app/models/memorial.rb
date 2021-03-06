class Memorial < ApplicationRecord
  include Likable

  belongs_to :user
  has_many :comments, as: :commentable

  mount_uploader :image, ImageUploader

  scope :recent, -> { order('id DESC') }
end
