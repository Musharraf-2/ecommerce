# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderedProduct, type: :model do
  subject(:ordered_product) { create(:ordered_product) }

  context 'database columns' do
    it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:price).of_type(:decimal).with_options(null: false) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:order_id).of_type(:integer) }
  end

  context 'database indexes' do
    it { is_expected.to have_db_index(:order_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:order) }
  end

  context 'validations' do
    context 'valid title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(40) }
      it 'expected title to be valid' do
        expect(ordered_product).to be_valid
      end
    end

    context 'invalid title' do
      it 'expected title to be invalid' do
        ordered_product.title = nil
        expect(ordered_product).not_to be_valid
      end
    end

    context 'valid price' do
      it { is_expected.to validate_presence_of(:price) }
      it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
      it 'expected price to be valid' do
        expect(ordered_product).to be_valid
      end
    end

    context 'invalid price' do
      it 'expected price to be invalid' do
        ordered_product.price = nil
        expect(ordered_product).not_to be_valid
      end
    end

    context 'valid quantity' do
      it { is_expected.to validate_presence_of(:quantity) }
      it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
      it 'expected quantity to be valid' do
        expect(ordered_product).to be_valid
      end
    end

    context 'invalid quantity' do
      it 'expected quantity to be invalid' do
        ordered_product.quantity = nil
        expect(ordered_product).not_to be_valid
      end
    end
  end
end
