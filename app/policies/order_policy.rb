class OrderPolicy < ApplicationPolicy
  def index?
    user.admin? || user.staff?
  end

  def show?
    index?
  end

  def create?
    user.admin? || user.staff?
  end

  def confirm?
    user.admin?
  end

  def ship?
    user.admin?
  end

  def cancel?
    user.admin?
  end
end
