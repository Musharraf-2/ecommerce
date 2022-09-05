class CreateWishlistProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :wishlist_products do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :product, index: true, foreign_key: true
      t.timestamps
    end
  end
end
