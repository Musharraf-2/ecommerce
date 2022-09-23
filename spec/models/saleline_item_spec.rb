# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalelineItem, type: :model do
  let!(:saleline_item) { create(:saleline_item) }
  let!(:user) { create(:user, id: 1) }
  let(:saleline_item1) { create(:saleline_item, user_id: 1, quantity: 10, price: 10) }
  let(:saleline_item2) { create(:saleline_item, user_id: 2, quantity: 10, price: 10) }
  let!(:order) { create(:order, user_id: 1) }

  context 'database columns' do
    it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:price).of_type(:decimal).with_options(null: false) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(40) }
    it 'title valid' do
      expect(saleline_item).to be_valid
    end

    it 'title invalid' do
      saleline_item.title = nil
      expect(saleline_item).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it 'price valid' do
      expect(saleline_item).to be_valid
    end

    it 'price invalid' do
      saleline_item.price = nil
      expect(saleline_item).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0).is_less_than(501) }
    it 'quantity valid' do
      expect(saleline_item).to be_valid
    end

    it 'quantity invalid' do
      saleline_item.quantity = nil
      expect(saleline_item).not_to be_valid
    end
  end

  describe '.map_products_to_signed_in_user' do
    it 'expected to map saleline items to user' do
      user = create(:user)
      create(:product, user_id: user.id)
      create(:product, user_id: user.id)
      SalelineItem.map_products_to_signed_in_user(user.id)
      expect(saleline_item.user_id).not_to eq(user.id)
    end
  end

  describe '.destroy_saleline_items_for_session' do
    it 'expected to delete saleline item for session' do
      SalelineItem.destroy_saleline_items_for_session(saleline_item.product_id)
      expect(SalelineItem.all).not_to include(saleline_item)
    end
  end

  describe '.calculate_total_amount' do
    context 'order for user exists' do
      it 'expected to return total' do
        total = saleline_item1.price * saleline_item1.quantity
        expect(SalelineItem.calculate_total_amount(1)).to eq(total)
      end
    end

    context 'order for user does not exists' do
      it 'expected to return total' do
        total = saleline_item2.price * saleline_item2.quantity
        total -= (total * 0.1)
        expect(SalelineItem.calculate_total_amount(2)).to eq(total)
      end
    end
  end
end
