# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.boolean :paid_status, default: false
      t.string :token, null: false
      t.decimal :amount, null: false
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
