# frozen_string_literal: true

class ProjectsController < AuthenticationController
  # skip_before_action :verify_authenticity_token

  def index
    @records = policy_scope(Project)
    authorize_records
  end

  def new
    @record = authorize Project.new
  end

  def create
    if (@project = current_user.projects.create(creation_params))
      redirect_to @project, notice: 'Project Created Successfully'
    end
  rescue PG::UniqueViolation, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    render :new, notice: 'Project Creation Unsuccessful'
  end

  def edit
    @users = User.unassigned(record.id)
    @assigned_users = record.users
  end

  def update
    if Projects::Updation.new(record.id, project_params).execute.present?
      redirect_to record, notice: 'Project Edited Successfully'
    else
      render 'edit', notice: 'Project Edit Unsuccessful'
    end
  end

  def show
    @project_users = record.users.pluck(:id, :name, :type, :email)
    @bugs = policy_scope(record.bugs)
  end

  def destroy
    redirect_to projects_path, notice: 'Project Deleted Successfully' if record.destroy
  end

  private

  def project_params
    params.require(:project)
          .permit(*%i[title description creator_id],
                  new_user_ids: [], removable_user_ids: [])
  end

  def creation_params
    project_params.except(:new_user_ids, :removable_user_ids)
  end
end
