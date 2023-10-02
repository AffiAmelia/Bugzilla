# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        @records = policy_scope(Project)
        render json: @records
      end
    end
  end
end
