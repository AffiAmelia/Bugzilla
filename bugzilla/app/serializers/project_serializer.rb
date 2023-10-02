# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :creator_id

  has_many :bugs
  has_many :users
end
