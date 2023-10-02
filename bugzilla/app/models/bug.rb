# frozen_string_literal: true

class Bug < ApplicationRecord
  BUG_STATUS_MAP = {
    New: 'pending',
    Started: 'started',
    Resolved: 'resolved'
  }.freeze

  FEATURE_STATUS_MAP = {
    New: 'pending',
    Started: 'started',
    Completed: 'completed'
  }.freeze

  CATEGORY_MAP = {
    Bug: :bug,
    Feature: :feature
  }.freeze

  belongs_to :project
  belongs_to :creator, class_name: :QualityAssurance, inverse_of: :reported_bugs
  belongs_to :assignee, class_name: :Developer, inverse_of: :assigned_bugs, optional: true

  has_one_attached :screenshot, dependent: :purge

  validates :category, :status, :deadline, presence: true
  validates :screenshot, blob: { content_type: %w[image/png image/gif] }
  validates :title, presence: true, uniqueness: { scope: :project_id }

  enum category: { bug: 0, feature: 1 }
  enum status: { pending: 0, started: 1, completed: 2, resolved: 3 }

  def possible_upcoming_statuses
    statuses.to_a[statuses.values.index(status)..statuses.values.size]
  end

  private

  def statuses
    "Bug::#{category.upcase}_STATUS_MAP".constantize
  end
end
