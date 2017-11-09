class DashboardPolicy < ApplicationPolicy

  def index?
  end

  def organization_super_admin?
  end

  def organization_dept_admin?
  end

  def organization_editors?
  end

  def organization_reviewers?
  end

  def organization_students?
  end

end
