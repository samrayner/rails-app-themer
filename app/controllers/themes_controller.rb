class ThemesController < ApplicationController
  layout false, only: :show
  helper_method :theme

  def show; end

  def edit; end

  def update
    theme.tap { |t| t.update! theme_params }.touch
    redirect_to edit_campaign_theme_path
  end

  private

  def theme
    @theme ||= Campaign.first.theme
  end

  def theme_params
    params.require(:theme).permit(*Theme::COLOR_VARS, *Theme::FONT_VARS,
      logo_atributes: [:id, :image, :_destroy, :image_cache])
  end
end
