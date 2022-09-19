# frozen_string_literal: true

class CreateOrderedProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :ordered_products do |t|
      t.string :title, null: false
      t.decimal :price, null: false
      t.integer :quantity, null: false
      t.references :order, index: true, foreign_key: true
      t.timestamps
    end
  end
end
