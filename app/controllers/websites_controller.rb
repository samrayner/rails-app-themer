class WebsitesController < ApplicationController
  def show
    @website = Website.first
  end
end
