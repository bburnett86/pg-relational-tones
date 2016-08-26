class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :email, null: false

      t.string :hashed_password, null: false

      t.text :obj_hash, null: false

      t.timestamps null: false
    end
  end
end
