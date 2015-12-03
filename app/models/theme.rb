class Theme < ActiveRecord::Base
  belongs_to :website

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
  store_accessor :colors, *COLOR_VARS.map{ |var| "#{var}_color" }

  FONT_VARS  = [:headings, :body]
  store_accessor :fonts, *FONT_VARS.map{ |var| "#{var}_font" }

  IMAGE_VARS  = [:logo]
  mount_uploader :logo, ImageUploader
  attr_accessor :logo_base64

  def color(var)
    value(:color, var) || INVALID_CSS_VALUE
  end

  def font(var)
    value(:font, var) || INVALID_CSS_VALUE
  end

  def image(image)
    image_src(image) || INVALID_CSS_VALUE
  end

  def image_url(image)
    url = image_src(image)
    url ? "url(#{url})" : INVALID_CSS_VALUE
  end

  private

  def value(type, var)
    attribute = "#{var}_#{type}"
    return nil unless respond_to?(attribute)
    send(attribute).try(:html_safe)
  end

  def image_src(image)
    send("#{image}_base64") || send(image).url
  end
end
