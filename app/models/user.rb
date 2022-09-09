# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products
  has_one_attached :image
  has_many :comments, dependent: :destroy

  validates :image, attached: true, content_type: ['image/png', 'image/jpeg']
end
