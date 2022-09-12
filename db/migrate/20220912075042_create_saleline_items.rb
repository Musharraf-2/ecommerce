# frozen_string_literal: true

class CreateSalelineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :saleline_items do |t|
      t.string :title, null: false
      t.decimal :price, null: false
      t.integer :quantity, null: false
      t.integer :user_id
      t.integer :product_id
      t.timestamps
    end
  end
end
