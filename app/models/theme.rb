class Theme < ActiveRecord::Base
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

  COLOR_VARS = [:background_color, :text_color]
  store_accessor :colors, *COLOR_VARS

  FONT_VARS  = [:headings_font, :body_font]
  store_accessor :fonts, *FONT_VARS

  IMAGE_VARS  = [:logo]
  mount_uploader :logo, ImageUploader
  attr_accessor :logo_base64

  belongs_to :campaign

  def color(var)
    css_value(:color, var)
  end

  def font(var)
    css_value(:font, var)
  end

  def image(image)
    image_src(image) || INVALID_CSS_VALUE
  end

  def image_url(image)
    url = image_src(image)
    url ? "url(#{url})" : INVALID_CSS_VALUE
  end

  private

  def image_src(image)
    send("#{image}_base64") || send(image).url
  end

  def css_value(type, var)
    var = var.to_s.gsub(/_#{type}$/, '')
    val = send(type.to_s.pluralize).try(:[], "#{var}_#{type}") || INVALID_CSS_VALUE
    val.html_safe
  end
end
