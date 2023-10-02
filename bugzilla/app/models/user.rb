# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self #, :confirmable

  MANAGER = 'Manager'
  DEVELOPER = 'Developer'
  QUALITY_ASSURANCE = 'QualityAssurance'
  TYPES_MAP = %w[manager developer quality_assurance].freeze

  has_many :project_users, dependent: :nullify
  has_many :projects, through: :project_users, dependent: :nullify

  validates :name, :email, :password, presence: true

  scope :except_managers, -> { where.not(type: MANAGER) }
  scope :assigned, ->(project_id) { joins(:project_users).where(project_users: { project_id: project_id }) }
  scope :unassigned, ->(project_id) { where.not(id: assigned(project_id)) }

  def name_with_email
    "Name: #{name}  Email: #{email}"
  end

  TYPES_MAP.each do |method|
    define_method("#{method}?") do
      type == method.camelize
    end
  end
end
