# frozen_string_literal: true

class AuthenticationController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  before_action :redirect_to_home, if: -> { current_user.blank? }

  protected

  def authorize_records
    @records.each do |record|
      authorize record
    end
  end

  def record
    @record ||= authorize model.find(params[:id])
  end

  private

  def redirect_to_home
    redirect_to home_index_path, alert: 'Please Login to your Account'
  end

  def unauthorized
    redirect_to projects_path, alert: 'Access Denied'
  end

  def model
    controller_path.classify.constantize
  end
end
