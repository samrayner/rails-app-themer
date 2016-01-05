class CreateThemeImages < ActiveRecord::Migration
  def change
    create_table :theme_images do |t|
      t.belongs_to :theme, index: true, foreign_key: true
      t.string :identifier
      t.string :image

      t.timestamps null: false
    end
  end
end
