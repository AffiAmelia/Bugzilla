# frozen_string_literal: true

class BugPolicy < ApplicationPolicy
  NEW_ROLES = %w[quality_assurance].freeze
  CREATE_ROLES = %w[quality_assurance].freeze
  DESTROY_ROLES = %w[quality_assurance].freeze
  EDIT_ROLES = %w[quality_assurance].freeze
  UPDATE_ROLES = %w[quality_assurance developer].freeze
  EDIT_STATUS_ROLES = %w[developer].freeze
  ALLOW_ASSIGNMENT_ROLES = %w[developer].freeze

  def edit_status?
    validate_type('edit_status') && record.deadline > Time.zone.now &&
      (!record.assignee_id? || record.assignee_id == user.id)
  end

  def allow_assignment?
    validate_type('allow_assignment') && record.status == 'pending'
  end
end
