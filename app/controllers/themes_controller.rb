class ThemesController < ApplicationController
  layout false, only: [:show, :preview]
  helper_method :theme, :preview_url

  def update
    theme.update!(theme_params)
    redirect_to edit_website_theme_path(preview_url: preview_params[:preview_url]),
      notice: "Theme updated."
  end

  def preview
    @theme = Theme.new(theme_params)
    render :show
  end

  private

  def theme
    @theme ||= Website.first.theme
  end

  def preview_url
    params[:preview_url] || root_url
  end

  def image_params
    Theme::IMAGE_VARS + Theme::IMAGE_VARS.map{ |v| "#{v}_base64" }
  end

  def theme_params
    params.require(:theme).permit(*Theme::COLOR_VARS, *Theme::FONT_VARS, *image_params)
  end

  def preview_params
    params.permit(:preview_url)
  end
end
