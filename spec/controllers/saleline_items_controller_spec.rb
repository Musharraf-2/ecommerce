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
        expect do
          post :create,
               params: { id: product.id }
        end.to change(SalelineItem, :count).by(1)
      end

      it 'expected session[:cart] to include product id' do
        expect(session[:cart]).to include(product.id)
      end
    end

    context 'saleline item is not created' do
      it 'expected not to increase saleline item count' do
        expect do
          post :create,
               params: { id: 1000 }
        end.to change(SalelineItem, :count).by(0)
      end

      it 'expected session[:cart] not to include product id' do
        expect(session[:cart]).not_to include(1000)
      end
    end

    it 'expected to redirect request referer' do
      expect(response).to redirect_to(request.referer)
    end
  end

  describe '#update' do
    before do
      login_user(user)
      request.env['HTTP_REFERER'] = root_path
    end

    context 'saleline item is updated' do
      before do
        patch :update, params: { saleline_item: { quantity: 20, saleline_item_id: saleline_item.id } }
      end

      it 'expected to update saleline item' do
        expect(saleline_item.reload.quantity).to eq(20)
      end

      it 'expected to show flash message' do
        expect(flash[:notice]).to eq('Quantity updated successfully.')
      end

      it 'expected to redirect request referer' do
        expect(response).to redirect_to(request.referer)
      end
    end

    context 'saleline item is not updated' do
      before do
        patch :update, params: { saleline_item: { quantity: 20, saleline_item_id: 999 } }
      end

      it 'expected not to update saleline item' do
        expect(saleline_item.quantity).not_to eq(20)
      end

      it 'expected to redirect request referer' do
        expect(response).to redirect_to(request.referer)
      end
    end
  end

  describe '#destroy' do
    before do
      login_user(user)
      request.env['HTTP_REFERER'] = root_path
      session[:cart] = []
      session[:cart] << product.id
    end

    context 'saleline item is deleted' do
      it 'expected to delete saleline item and product id from session' do
        expect do
          delete :destroy,
                 params: { id: product.id }
        end.to change(SalelineItem, :count).by(-1)
        expect(session[:cart]).not_to include(product.id)
      end
    end

    context 'saleline item is not deleted' do
      it 'expected not to delete saleline item and product id from session' do
        allow_any_instance_of(SalelineItem).to receive(:destroy).and_return(false)
        expect do
          delete :destroy,
                 params: { id: product.id }
        end.to change(SalelineItem, :count).by(0)
        expect(session[:cart]).to include(product.id)
      end
    end
  end
end
