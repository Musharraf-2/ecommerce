# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit update destroy]
  before_action :set_product, only: %i[create edit update destroy]
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = @product.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to product_path(@product)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end
end
