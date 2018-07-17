class Micropost < ApplicationRecord
  belongs_to :user
  scope :micropost_desc, -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.maximum.length_content }
  validate :picture_size

  private

  def picture_size
    return if picture.size <= Settings.maximum_megabytes
    errors.add :picture, t("max_size")
  end
end
