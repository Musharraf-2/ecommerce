# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit update destroy]
  before_action :set_product, only: %i[create edit update destroy]
  before_action :set_comment, only: %i[edit update destroy]

  def create
    @comment = @product.comments.new(comment_params)
    @comment.save
  end

  def edit
    authorize @comment
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to product_path(@product)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end
end
