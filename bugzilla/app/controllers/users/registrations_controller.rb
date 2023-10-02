# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: :create
    before_action :configure_account_update_params, only: :update

    # rubocop:disable Lint/UselessMethodDefinition
    def create
      super
    end

    def update
      super
    end
    # rubocop:enable Lint/UselessMethodDefinition

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name type])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name type])
    end
  end
end
