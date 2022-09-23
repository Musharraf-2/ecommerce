# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:product) { user.products.create(attributes_for(:product)) }

  context 'callbacks' do
    it { is_expected.to use_before_action(:set_product) }
    it { is_expected.to use_before_action(:authorize_product) }
    it { is_expected.to use_before_action(:initialize_cart) }
  end

  context 'routes' do
    it { is_expected.to route(:get, '/').to(action: :index) }
    it { is_expected.to route(:get, '/products/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/products/new').to(action: :new) }
    it { is_expected.to route(:get, '/products/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:post, '/products').to(action: :create) }
    it { is_expected.to route(:put, '/products/1').to(action: :update, id: 1) }
    it { is_expected.to route(:patch, '/products/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/products/1').to(action: :destroy, id: 1) }
    it { is_expected.to route(:get, 'products/dashboard').to(action: :dashboard) }
    it { is_expected.to route(:get, 'products/search').to(action: :search) }
  end

  describe '#index' do
    before do
      get :index
    end
    it 'expected to have status 200' do
      expect(response).to have_http_status(200)
    end
    it 'expected to render index template' do
      expect(response).to render_template('index')
    end
  end

  describe '#search' do
    before do
      get :search, xhr: true, format: :json, params: { key: product.title }
    end
    it 'expected to have status 200' do
      expect(response).to have_http_status(200)
    end
    it 'expected to respond in json' do
      expect(JSON.parse(response.body)[0]['title']).to eq(product.title)
    end
  end

  describe '#show' do
    context 'product exists' do
      before do
        get :show, params: { id: product.id }
      end
      it 'expected to have status 200' do
        expect(response).to have_http_status(200)
      end
      it 'expected to render show template' do
        expect(response).to render_template('show')
      end
    end
    context 'product does not exists' do
      before do
        get :show, params: { id: 1000 }
        get :index
      end
      it 'expected to render index template' do
        expect(response).to render_template('index')
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('The record you are asking does not exists.')
      end
    end
  end

  describe '#new' do
    context 'user signed in' do
      before do
        login_user(user)
        get :new
      end
      it 'expected to have status 200' do
        expect(response).to have_http_status(200)
      end
      it 'expected to render new template' do
        expect(response).to render_template('new')
      end
    end
    context 'user not signed in' do
      before do
        get :new
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe '#create' do
    context 'user not signed in' do
      before do
        post :create
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
    context 'user signed in' do
      before do
        login_user(user)
      end
      context 'valid product' do
        before do
          post :create, params: { product: attributes_for(:product) }
        end
        it 'expected to assign values to product' do
          expect(assigns(:product)).not_to eq nil
        end
        it 'expected to redirect to product dashboard page' do
          expect(response).to redirect_to(dashboard_products_path)
        end
        it 'expected to show flash message' do
          expect(flash[:notice]).to eq('Product created successfully.')
        end
      end
      context 'invalid product' do
        before do
          post :create, params: { product: { title: nil } }
        end
        it 'expected to render new template' do
          expect(response).to render_template('new')
        end
      end
    end
  end

  describe '#edit' do
    context 'user not signed in' do
      before do
        get :edit, params: { id: product.id }
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
    context 'user signed in' do
      before do
        login_user(user)
      end
      context 'product exists' do
        before do
          get :edit, params: { id: product.id }
        end
        it 'expected to have status 200' do
          expect(response).to have_http_status(200)
        end
        it 'expected to render edit template' do
          expect(response).to render_template('edit')
        end
      end
      context 'product does not exists' do
        before do
          get :edit, params: { id: 2000 }
          get :index
        end
        it 'expected to render index template' do
          expect(response).to render_template('index')
        end
        it 'expected to show flash message' do
          expect(flash[:alert]).to eq('The record you are asking does not exists.')
        end
      end
    end
  end

  describe '#dashboard' do
    context 'user not signed in' do
      before do
        get :dashboard
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
    context 'user signed in' do
      before do
        login_user(user)
        get :dashboard
      end
      it 'expected to have status 200' do
        expect(response).to have_http_status(200)
      end
      it 'expected to render dashboard template' do
        expect(response).to render_template('dashboard')
      end
    end
  end

  describe 'destroy' do
    context 'user not signed in' do
      before do
        delete :destroy, params: { id: product.id }
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
    context 'user signed in' do
      before do
        login_user(user)
        session[:cart] = []
        session[:cart] << product.id
        get :dashboard
      end
      context 'product exists' do
        context 'delete product' do
          it 'expected to delete product' do
            expect do
              delete :destroy,
                     params: { id: product.id }
            end.to change(Product, :count).by(-1)
          end
          it 'expected to render dashboard template' do
            expect(response).to render_template('dashboard')
          end
        end
        context 'cannot delete product' do
          it 'expected not to delete product' do
            allow_any_instance_of(Product).to receive(:destroy).and_return(false)
            expect do
              delete :destroy, params: { id: product.id }
            end.to change(Product, :count).by(0)
          end
          it 'expected to render dashboard template' do
            expect(response).to render_template('dashboard')
          end
        end
      end
      context 'product does not exists' do
        before do
          delete :destroy, params: { id: 2000 }
          get :index
        end
        it 'expected to render index template' do
          expect(response).to render_template('index')
        end
        it 'expected to show flash message' do
          expect(flash[:alert]).to eq('The record you are asking does not exists.')
        end
      end
    end
  end

  describe '#update' do
    context 'user not signed in' do
      before do
        patch :update, params: { product: attributes_for(:product), id: product.id }
      end
      it 'expected to show flash message' do
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
    context 'user signed in' do
      before do
        login_user(user)
      end
      context 'valid product' do
        before do
          patch :update, params: { product: attributes_for(:product), id: product.id }
        end
        it 'expected to assign values to product' do
          expect(assigns(:product)).not_to eq nil
        end
        it 'expected to redirect to product dashboard page' do
          expect(response).to redirect_to(dashboard_products_path)
        end
        it 'expected to show flash message' do
          expect(flash[:notice]).to eq('Product updated successfully.')
        end
      end
      context 'invalid product' do
        before do
          patch :update, params: { product: { title: nil }, id: product.id }
          get :edit, params: { id: product.id }
        end
        it 'expected to render edit template' do
          expect(response).to render_template('edit')
        end
      end
    end
  end
end
