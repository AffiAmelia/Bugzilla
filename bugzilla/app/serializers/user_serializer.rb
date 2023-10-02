# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :email

  has_many :projects
end
