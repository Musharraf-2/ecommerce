# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }
  let(:product) { create(:product, user_id: subject.id) }

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
    context 'valid email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
      it 'expected email to be valid' do
        expect(user).to be_valid
      end
    end

    context 'invalid email' do
      it 'expected email to be invalid' do
        user.email = nil
        expect(user).not_to be_valid
      end
    end

    context 'valid password' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
      it 'expected password to be valid' do
        expect(user).to be_valid
      end
    end

    context 'invalid password' do
      it 'expected password to be invalid' do
        user.password = nil
        expect(user).not_to be_valid
      end
    end
  end

  describe '.user_for_email' do
    before do
      create(:wishlist_product, user_id: subject.id, product_id: product.id)
    end
    context 'get all users for email' do
      it 'expected to return users for email' do
        expect(described_class.users_for_email(product.id)).to include(user)
      end
    end

    context 'get no user for email' do
      it 'expected to return no users for email' do
        expect(described_class.users_for_email(5)).not_to include(user)
      end
    end
  end
end
