# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:user) { create(:user) }
  let!(:product) { create(:product, user_id: user.id) }

  context 'database columns' do
    it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:price).of_type(:decimal).with_options(null: false) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:serial_number).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  context 'database indexes' do
    it { is_expected.to have_db_index(:serial_number).unique(true) }
    it { is_expected.to have_db_index(:user_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:wishlist_products).dependent(:destroy) }
    it { is_expected.to have_many_attached(:images) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(40) }
    it 'title valid' do
      expect(product).to be_valid
    end
    it 'title invalid' do
      product.title = nil
      expect(product).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_least(5).is_at_most(500) }
    it 'description valid' do
      expect(product).to be_valid
    end
    it 'description invalid' do
      product.description = nil
      expect(product).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0).is_less_than(100_000) }
    it 'price valid' do
      expect(product).to be_valid
    end
    it 'price invalid' do
      product.price = nil
      expect(product).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0).is_less_than(501) }
    it 'quantity valid' do
      expect(product).to be_valid
    end
    it 'quantity invalid' do
      product.quantity = nil
      expect(product).not_to be_valid
    end
  end

  describe '.send_emails' do
    it 'expected different old and new price' do
      expect(product.send_emails(999)).not_to eq(product.price)
    end
    let!(:wishlist_product) { create(:wishlist_product, user_id: user.id, product_id: product.id) }
    it 'expected to return users emails' do
      expect(User.users_for_email(product.id).pluck(:email)).to include(user.email)
    end
  end
end
