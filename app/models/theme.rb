class Theme < ActiveRecord::Base
  # CSS property value for invalidating any rule it's used in
  # When the browser encounters it, it's ignored and the fallback is used
  INVALID_CSS_VALUE = ':'

  COLOR_VARS = [:background_color, :text_color]
  FONT_VARS  = [:headings_font, :body_font]

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

  store_accessor :colors, *COLOR_VARS
  store_accessor :fonts, *FONT_VARS
  belongs_to :campaign

  mount_uploader :logo, LogoUploader

  def color(key)
    val = colors.try(:[], "#{key}_color") || INVALID_CSS_VALUE
    val.html_safe
  end

  def font(key)
    val = fonts.try(:[], "#{key}_font") || INVALID_CSS_VALUE
    val.html_safe
  end
end
