# frozen_string_literal: true

class Manager < User
  has_many :projects, dependent: :destroy, foreign_key: :creator_id, inverse_of: :creator
end
