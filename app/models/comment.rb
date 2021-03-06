class Comment < ApplicationRecord
  include Likable
  include Choosable
  include Reportable

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  geocoded_by :full_street_address

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  mount_uploader :image, ImageUploader

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }

  validates :body, presence: true
  validates :commenter_email, format: { with: Devise.email_regexp }, if: 'commenter_email.present?'
  validate :commenter_should_be_present_if_user_is_blank
  after_validation :fetch_geocode, if: ->(obj){ obj.full_street_address.present? and obj.full_street_address_changed? }

  before_save :save_gps

  def user_nickname
    user.present? ? user.nickname : commenter_name
  end

  private

  def save_gps
    begin
      if self.image.present?
        gps = EXIFR::JPEG.new(self.image.file.path).gps
        if gps.present?
          self.latitude = gps.latitude
          self.longitude = gps.longitude
        end
      end
    rescue EXIFR::MalformedJPEG => e
    end
  end

  def commenter_should_be_present_if_user_is_blank
    if user.blank? and commenter_name.blank?
      errors.add(:commenter_name, I18n.t('activerecord.errors.models.comment.commenter.blank'))
    end
  end

  private

  def fetch_geocode
    self.latitude = nil
    self.longitude = nil
    geocode
  end
end
