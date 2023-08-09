class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :category, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
