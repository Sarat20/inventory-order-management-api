class CategoryPolicy < ApplicationPolicy
  def index?
    user.admin? || user.staff?
  end

  def show?
    index?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
