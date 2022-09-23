# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalelineItemsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:saleline_item) { create(:saleline_item, product_id: product.id) }
  context 'routes' do
    it { is_expected.to route(:post, '/saleline_item').to(action: :create) }
    it { is_expected.to route(:put, '/saleline_item').to(action: :update) }
    it { is_expected.to route(:patch, '/saleline_item').to(action: :update) }
    it { is_expected.to route(:delete, '/saleline_item').to(action: :destroy) }
  end

  describe '#create' do
    before do
      login_user(user)
      request.env['HTTP_REFERER'] = root_path
      session[:cart] = []
      post :create, params: { id: product.id }
    end
    context 'saleline item is created' do
      it 'expected to create saleline item' do
        expect(SalelineItem.last.quantity).to eq(1)
      end
      it 'expected to increase saleline item count' do
        expect(change(SalelineItem, :count).by(1))
      end
      it 'expected session[:cart] to include product id' do
        expect(session[:cart]).to include(product.id)
      end
    end
    it 'expected to redirect request referer' do
      expect(response).to redirect_to(request.referer)
    end
  end

  describe '#update' do
    before do
      login_user(user)
      request.env['HTTP_REFERER'] = products_path
      patch :update, params: { saleline_item: { quantity: 20, saleline_item_id: saleline_item.id } }
    end
    it 'expected to update saleline item' do
      expect(SalelineItem.last.quantity).to eq(20)
    end
    it 'expected to show flash message' do
      expect(flash[:notice]).to eq('Quantity updated successfully.')
    end
    it 'expected to redirect request referer' do
      expect(response).to redirect_to(request.referer)
    end
  end

  describe '#destroy' do
    before do
      login_user(user)
      request.env['HTTP_REFERER'] = products_path
      session[:cart] = []
      session[:cart] << product.id
    end
    context 'saleline item is deleted' do
      it 'expected to delete saleline item' do
        expect do
          delete :destroy,
                 params: { id: product.id }
        end.to change(SalelineItem, :count).by(-1)
      end
      it 'expected session[:cart] not to include product id' do
        expect(session).not_to include(product.id)
      end
    end
  end
end
