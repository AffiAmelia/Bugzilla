# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  CREATE_PROJECT_BUTTON_ROLES = %w[manager].freeze
  ADD_BUG_BUTTON_ROLES = %w[quality_assurance].freeze
  EDIT_BUG_BUTTON_ROLES = %w[quality_assurance].freeze

  def create_project_button?
    validate_type('create_project_button')
  end

  def add_bug_button?
    validate_type('add_bug_button')
  end

  def edit_bug_button?
    validate_type('edit_bug_button')
  end
end
