class Tracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|

      t.string :name, default: "untitled"

      t.string :artist_name, default: "unknown"

      t.string :album_name, default: "untitled"

      t.float :danceability, null: false

      t.float :tempo, null: false

      t.float :energy, null: false

      t.float :loudness, null: false

      t.float :liveness, null: false

      t.float :acousticness, null: false

      t.float :valence, null: false

      t.float :speechiness, null: false

      t.text :obj_hash, null: false

      t.timestamps null: false
    end
  end
end
