# frozen_string_literal: true

module Projects
  class Updation
    attr_accessor :project, :params

    def initialize(id, params)
      @project = Project.find(id)
      @params = params
    end

    def execute
      update_record
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      nil
    end

    private

    def update_record
      ActiveRecord::Base.transaction do
        project.project_users.where(user_id: removable_user_ids)&.destroy_all
        project.project_users.create!(new_users_payload)
        project.update!(params.except(:new_user_ids, :removable_user_ids))
      end
    end

    def new_users_payload
      (params[:new_user_ids] - params[:removable_user_ids]).map do |id|
        { user_id: id }
      end
    end

    def removable_user_ids
      params[:removable_user_ids] - params[:new_user_ids]
    end
  end
end
