class Campaign < ActiveRecord::Base
  has_one :theme

  after_create :create_theme

  private

  def create_theme
    Theme.create(campaign_id: self.id)
  end
end
