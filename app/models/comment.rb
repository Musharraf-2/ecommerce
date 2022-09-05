class Comment < ApplicationRecord
  belongs_to :user, :product

  validates :body, presence: true, length: {in 5..500}
end
