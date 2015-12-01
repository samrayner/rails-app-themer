class ThemesController < ApplicationController
  layout false
  helper_method :theme

  def show; end
  def edit; end

  def update

  end

  private

  def theme
    @theme ||= Campaign.first.theme
  end
end
