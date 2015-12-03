class ThemesController < ApplicationController
  layout false, only: [:show, :preview]
  helper_method :theme, :preview_url

  def show
    render :show if stale?(theme)
  end

  def update
    theme.update!(theme_params)
    Rails.cache.delete('theme')
    redirect_to edit_website_theme_path(preview_url: preview_params[:preview_url]),
      notice: "Theme updated."
  end

  def preview
    @theme = Theme.new(theme_params)
    render :show
  end

  private

  def theme
    @theme ||= Rails.cache.fetch('theme', expires_in: 1.year) do
      Website.first.theme
    end
  end

  def preview_url
    params[:preview_url] || root_url
  end

  def theme_params
    params.require(:theme).permit(
      *Theme::COLOR_VARS.map{ |v| "#{v}_color" },
      *Theme::FONT_VARS.map{ |v| "#{v}_font" },
      *(Theme::IMAGE_VARS + Theme::IMAGE_VARS.map{ |v| "#{v}_base64" })
    )
  end

  def preview_params
    params.permit(:preview_url)
  end
end
