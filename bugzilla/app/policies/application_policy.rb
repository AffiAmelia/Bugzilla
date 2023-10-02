# frozen_string_literal: true

class ApplicationPolicy
  INDEX_ROLES = %w[manager developer quality_assurance].freeze
  SHOW_ROLES = %w[manager developer quality_assurance].freeze
  NEW_ROLES = %w[manager developer quality_assurance].freeze
  CREATE_ROLES = %w[manager developer quality_assurance].freeze
  EDIT_ROLES = %w[manager developer quality_assurance].freeze
  UPDATE_ROLES = %w[manager developer quality_assurance].freeze
  DELETE_ROLES = %w[manager developer quality_assurance].freeze

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  %w[index new create edit update destroy show].each do |method|
    define_method("#{method}?") do
      validate_type(method)
    end
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    protected

    attr_reader :user, :scope
  end

  protected

  def validate_type(method)
    user.present? && "#{self.class}::#{method.upcase}_ROLES".constantize.include?(user.type.underscore)
  end
end
