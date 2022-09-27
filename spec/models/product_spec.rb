# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:user) { create(:user) }
  subject(:product) { create(:product, user_id: user.id) }
  subject(:product1) { create(:product, user_id: user.id) }

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
    context 'valid title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(40) }
      it 'expected title to be valid' do
        expect(product).to be_valid
      end
    end

    context 'invalid title' do
      it 'expected title to be invalid' do
        product.title = nil
        expect(product).not_to be_valid
      end
    end

    context 'valid description' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_length_of(:description).is_at_least(5).is_at_most(500) }
      it 'expected description to be valid' do
        expect(product).to be_valid
      end
    end

    context 'invalid description' do
      it 'expected description to be invalid' do
        product.description = nil
        expect(product).not_to be_valid
      end
    end

    context 'valid price' do
      it { is_expected.to validate_presence_of(:price) }
      it { is_expected.to validate_numericality_of(:price).is_greater_than(0).is_less_than(100_000) }
      it 'expected price to be valid' do
        expect(product).to be_valid
      end
    end

    context 'invalid price' do
      it 'expected price to be invalid' do
        product.price = nil
        expect(product).not_to be_valid
      end
    end

    context 'valid quantity' do
      it { is_expected.to validate_presence_of(:quantity) }
      it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0).is_less_than(501) }
      it 'expected price to valid' do
        expect(product).to be_valid
      end
    end

    context 'invalid quantity' do
      it 'expected price to valid' do
        product.quantity = nil
        expect(product).not_to be_valid
      end
    end

    context 'valid images' do
      it 'expected images type to be jpeg' do
        expect(product.images[0].blob.content_type).to eq('image/jpeg')
      end

      it 'expected images type to be png' do
        expect(product.images[1].blob.content_type).to eq('image/png')
      end
    end

    context 'invalid images' do
      it 'expected images type not to be png or jpeg' do
        expect do
          create(:product,
                 images: [Rack::Test::UploadedFile.new('app/assets/images/car.webp', 'product.webp')])
        end.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end

    context 'valid serial_number' do
      before do
        Product.skip_callback(:validation, :before, :generate_unique_serial_number, raise: false)
      end

      it { is_expected.to validate_presence_of(:serial_number) }
      it { is_expected.to validate_uniqueness_of(:serial_number).ignoring_case_sensitivity }
      it 'expected serial_number to be valid' do
        expect(product1).to be_valid
      end
    end

    context 'invalid serial_number' do
      it 'expected serial_number to be invalid' do
        product.serial_number = nil
        expect(product).not_to be_valid
      end
    end
  end

  describe '.send_emails' do
    before do
      create(:wishlist_product, user_id: user.id, product_id: product.id)
    end

    context 'old and  new price are different' do
      context 'price changed' do
        it 'expected different old and new price' do
          expect(product.send_emails(999)).not_to eq(product.price)
        end
      end

      context 'return users email' do
        it 'expected to return users emails' do
          expect(User.users_for_email(product.id).pluck(:email)).to include(user.email)
        end
      end

      context 'queue emails' do
        it 'expected to queue emails' do
          ActiveJob::Base.queue_adapter = :test
          expect do
            product.send_emails(999)
          end.to have_enqueued_mail(UserMailer, :price_changed_email)
        end
      end
    end

    context 'old and new price are same' do
      context 'return no users email' do
        it 'expected not to return users emails' do
          expect(User.users_for_email(999).pluck(:email)).not_to include(user.email)
        end
      end

      context 'do not queue emails' do
        it 'expected not to queue emails' do
          ActiveJob::Base.queue_adapter = :test
          expect do
            product.send_emails(product.price)
          end.not_to have_enqueued_mail(UserMailer, :price_changed_email)
        end
      end
    end
  end

  describe '.generate_unique_serial_number' do
    context 'unique serial number for both products' do
      it 'expected that serial number will not be same' do
        expect(product.serial_number).not_to eq(product1.serial_number)
      end
    end
  end
end
