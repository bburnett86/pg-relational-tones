class Selections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.references :playlist, null: false

      t.references :track, null: false
    end
  end
end
