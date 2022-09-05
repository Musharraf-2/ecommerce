class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products
  has_many :wishlist_products
  has_many :comments
  has_many :orders

  validates :email, :encrypted_password, presence: true
  validates :email, uniqueness: { message: "User with this email already exists." }
end
