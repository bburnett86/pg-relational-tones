class Playlists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|

      t.string :name, default: "untitled"

      t.references :user, null: false

      t.text :obj_hash, null: false

      t.timestamps null: false
    end
  end
end
