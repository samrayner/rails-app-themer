class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.first
  end
end
