class AddIndexes < ActiveRecord::Migration
  def change
    add_index(:selections, :playlist_id)
    add_index(:selections, :track_id)
    add_index(:selections, [:playlist_id, :track_id])
  end
end
