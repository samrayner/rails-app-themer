class Theme < ActiveRecord::Base
  belongs_to :website
  has_many :images, foreign_key: 'theme_id', class_name: 'ThemeImage'
  accepts_nested_attributes_for :images

  # CSS property value for invalidating any rule it's used in
  # When the browser encounters it, it's ignored and the fallback is used
  INVALID_CSS_VALUE = ':'

  FONT_STACKS = {
    'Helvetica':
      '"Helvetica Neue", Helvetica, Arial, sans-serif',
    'Lucida Grande':
      '"Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", Geneva, Verdana, sans-serif',
    'Gill Sans':
      '"Gill Sans", "Gill Sans MT", Calibri, sans-serif',
    'Palatino':
      'Palatino, "Palatino Linotype", "Palatino LT STD", "Book Antiqua", Georgia, serif',
    'Baskerville':
      'Baskerville, "Baskerville Old Face", "Hoefler Text", Garamond, "Times New Roman", serif',
    'Times':
      '"Times New Roman", Times, serif'
  }

  COLOR_VARS = [:background, :text]
  FONT_VARS  = [:headings, :body]
  IMAGE_VARS  = [:background, :logo]

  store_accessor :colors, *COLOR_VARS.map{ |var| "#{var}_color" }
  store_accessor :fonts, *FONT_VARS.map{ |var| "#{var}_font" }
  attr_accessor :image_previews

  def color(var)
    value(:color, var) || INVALID_CSS_VALUE
  end

  def rgba(var, alpha)
    hex = value(:color, var)
    return INVALID_CSS_VALUE unless hex
    r, g, b = hex.sub('#', '').scan(/../).map{ |c| c.to_i(16) }
    "rgba(#{r}, #{g}, #{b}, #{alpha})"
  end

  def font(var)
    value(:font, var) || INVALID_CSS_VALUE
  end

  def image_url(var)
    url = image(var)
    url ? "url(#{url})" : INVALID_CSS_VALUE
  end

  def image(identifier)
    preview = image_previews.try(:[], identifier.to_s)
    preview || images.find_by(identifier: identifier).try(:image).try(:url)
  end

  private

  def value(type, var)
    attribute = "#{var}_#{type}"
    return nil unless respond_to?(attribute)
    value = send(attribute)
    value.present? ? value.html_safe : nil
  end
end
