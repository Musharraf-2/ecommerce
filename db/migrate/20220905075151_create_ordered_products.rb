class CreateOrderedProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :ordered_products do |t|
      t.int :quantity, null: false
      t.decimal :price, null: false
      t.belongs_to :order, :product, index: true, foreign_key: true
      t.timestamps
    end
  end
end
