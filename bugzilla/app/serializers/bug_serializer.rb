# frozen_string_literal: true

class BugSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :description, :status, :deadline

  has_many :projects
end
