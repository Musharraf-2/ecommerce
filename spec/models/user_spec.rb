# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  context 'database columns' do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, default: '') }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: '') }
  end

  context 'database indexes' do
    it { is_expected.to have_db_index(:email).unique(true) }
  end

  context 'associations' do
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:wishlist_products).dependent(:destroy) }
    it { is_expected.to have_one_attached(:image) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it 'email valid' do
      expect(user).to be_valid
    end

    it 'email invalid' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it 'password valid' do
      expect(user).to be_valid
    end

    it 'password invalid' do
      user.password = nil
      expect(user).not_to be_valid
    end
  end

  describe '.user_for_email' do
    let!(:product) { create(:product, user_id: user.id) }
    let!(:wishlist_product) { create(:wishlist_product, user_id: user.id, product_id: product.id) }
    it 'expected to return users for email' do
      expect(User.users_for_email(product.id)).to include(user)
    end

    it 'expected to return no users for email' do
      expect(User.users_for_email(5)).not_to include(user)
    end
  end
end
