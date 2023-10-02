# frozen_string_literal: true

class BugsController < AuthenticationController
  skip_before_action :verify_authenticity_token

  before_action :initailze_bug, only: :create

  def new
    @record = authorize Bug.new
    @projects = policy_scope(Project)
  end

  def create
    redirect_to project_path(record.project) if @record.save
  end

  def edit
    record
    @projects = policy_scope(Project)
  end

  def update
    if record.update(updation_params)
      redirect_to project_path(record.project)
    else
      render :edit
    end
  end

  def show
    redirect_to project_path(record.project)
  end

  def destroy
    redirect_to projects_path, notice: 'Bug Deleted Successfully' if record.destroy
  end

  private

  def bug_params
    params.require(:bug).permit(%i[title category status description project_id deadline])
  end

  def updation_params
    return bug_params unless allow_assignment?

    bug_params.merge(assignee_id: current_user.id)
  end

  def initailze_bug
    @record = current_user.reported_bugs.new(bug_params)
    record.screenshot.attach(params.dig(:bug, :screenshot))
  end

  def allow_assignment?
    policy(record).allow_assignment? && params.dig(:bug, :status) == Bug::BUG_STATUS_MAP[:Started]
  end
end
