class ThemesController < ApplicationController
  layout false, only: [:show, :preview]
  helper_method :theme

  def show; end

  def edit; end

  def update
    theme.update!(theme_params)
    redirect_to edit_campaign_theme_path, { notice: "Theme updated." }
  end

  def preview
    @theme = Theme.new(theme_params)
    render :show
  end

  private

  def theme
    @theme ||= Campaign.first.theme
  end

  def theme_params
    params.require(:theme).permit(*Theme::COLOR_VARS, *Theme::FONT_VARS, :logo, :logo_base64)
  end
end
