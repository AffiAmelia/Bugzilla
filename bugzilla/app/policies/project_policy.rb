# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  NEW_ROLES = %w[manager].freeze
  CREATE_ROLE = %w[manager].freeze
  EDIT_ROLES = %w[manager].freeze
  UPDATE_ROLES = %w[manager].freeze
  DESTROY_ROLES = %w[manager].freeze

  %w[edit update destroy].each do |method|
    define_method("#{method}?") do
      validate_type(method) && record.creator_id == user.id
    end
  end

  def show?
    super && (!user.developer? || record.project_users.exists?(user_id: user.id))
  end

  class Scope < Scope
    def resolve
      if user.developer?
        scope.joins(:project_users).where(project_users: { user_id: user.id })
      else
        scope.all
      end
    end
  end
end
