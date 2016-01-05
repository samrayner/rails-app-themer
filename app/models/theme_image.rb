class ThemeImage < ActiveRecord::Base
  belongs_to :theme, touch: true

  validates_presence_of :theme, :identifier
  validates_uniqueness_of :identifier

  mount_uploader :image, ImageUploader
  attr_accessor :base64

  scope :unused, -> { where.not(identifier: Theme::IMAGE_VARS) }
end
