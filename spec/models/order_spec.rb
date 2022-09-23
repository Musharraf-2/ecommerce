# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:order) { create(:order) }

  context 'database columns' do
    it { is_expected.to have_db_column(:paid_status).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:token).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:amount).of_type(:decimal).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  context 'database indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:ordered_products).dependent(:destroy) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:token) }
    it 'token valid' do
      expect(order).to be_valid
    end

    it 'token invalid' do
      order.token = nil
      expect(order).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it 'amount valid' do
      expect(order).to be_valid
    end

    it 'amount invalid' do
      order.amount = nil
      expect(order).not_to be_valid
    end

    it { is_expected.to validate_inclusion_of(:paid_status).in_array([true, false]) }
    it 'paid_status valid' do
      expect(order).to be_valid
    end

    it 'paid_status invalid' do
      order.paid_status = nil
      expect(order).not_to be_valid
    end
  end
end
