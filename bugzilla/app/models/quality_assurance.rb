# frozen_string_literal: true

class QualityAssurance < User
  has_many :reported_bugs, class_name: :Bug, dependent: :destroy, foreign_key: :creator_id, inverse_of: :creator
end
