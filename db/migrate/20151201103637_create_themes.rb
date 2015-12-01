class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.belongs_to :campaign, index: true, foreign_key: true
      t.hstore :colors
      t.hstore :fonts
      t.string :logo

      t.timestamps null: false
    end
  end
end
