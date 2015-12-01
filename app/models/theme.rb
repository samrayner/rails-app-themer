class Theme < ActiveRecord::Base
  # CSS property value for invalidating any rule it's used in
  # When the browser encounters it, it's ignored and the fallback is used
  INVALID_CSS_VALUE = ':'

  COLOR_VARS = [:background, :text]
  FONT_VARS  = [:headings, :body]

  store_accessor :colors, *COLOR_VARS
  store_accessor :fonts, *FONT_VARS
  belongs_to :campaign

  mount_uploader :logo, LogoUploader

  def color(key)
    #return invalid CSS if nil so rule gets ignored
    colors.try(:[], key.to_s) || INVALID_CSS_VALUE
  end

  def font(key)
    #return invalid CSS if nil so rule gets ignored
    fonts.try(:[], key.to_s) || INVALID_CSS_VALUE
  end
end
