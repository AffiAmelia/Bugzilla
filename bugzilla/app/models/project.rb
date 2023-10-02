# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :bugs, dependent: :destroy
  has_many :project_users, dependent: :nullify
  has_many :users, through: :project_users

  belongs_to :creator, class_name: :Manager

  validates :title, presence: true
end
