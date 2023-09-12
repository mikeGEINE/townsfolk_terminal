class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.references :category, null: false, foreign_key: true
      t.string :door
      t.string :code, default: 'change_me'
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
