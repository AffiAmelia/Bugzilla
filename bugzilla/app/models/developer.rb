# frozen_string_literal: true

class Developer < User
  has_many :assigned_bugs, class_name: :Bug, dependent: :nullify, foreign_key: :assignee_id, inverse_of: :assignee
end
