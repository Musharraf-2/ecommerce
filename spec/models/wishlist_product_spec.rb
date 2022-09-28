# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WishlistProduct, type: :model do
  subject(:wishlist_product) { create(:wishlist_product) }

  context 'database columns' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
  end

  context 'database indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:product_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:product) }
  end
end
