# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) { create(:comment) }

  context 'database columns' do
    it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
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

  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_least(5).is_at_most(500) }
    it 'expected comment to be valid' do
      expect(comment).to be_valid
    end
    it 'expected comment not to be valid' do
      comment.body = nil
      expect(comment).not_to be_valid
    end
  end
end
