# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def update?
    user.id == record.user.id
  end

  def edit?
    user.id == record.user.id
  end

  def destroy?
    user.id == record.user.id
  end
end
