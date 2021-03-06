class Website < ActiveRecord::Base
  has_one :theme

  after_create :create_theme

  private

  def create_theme
    Theme.create(website: self)
  end
end
