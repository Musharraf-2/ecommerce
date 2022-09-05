class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :price, null: false
      t.integer :quantity, null: false
      t.string :serial_number, null: false, index: { unique: true }
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
