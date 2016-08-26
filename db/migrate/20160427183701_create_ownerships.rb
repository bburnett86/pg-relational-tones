class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|

      t.references :owner, null: false

      t.references :track, null: false

      t.timestamps null: false
    end
  end
end
