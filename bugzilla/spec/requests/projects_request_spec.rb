# frozen_string_literal: true

require 'rails_helper'
DatabaseCleaner.cleaning do
  RSpec.describe Project, type: :request do
    let(:user) { FactoryBot.create(:user) }
    let(:user_dev) { FactoryBot.build(:user, type: 'Developer') }
    let(:user_qa) { FactoryBot.build(:user, type: 'QualityAssurance') }
    let(:project) { FactoryBot.create(:project, creator_id: user.id) }

    describe 'GET #Index' do
      context 'when user authenticated ' do
        before do
          sign_in user
          get projects_path
        end

        it 'returns index page' do
          expect(response).to be_successful
        end
      end

      context 'when user not signed_in' do
        it 'returns login page' do
          get projects_path
          expect(response).to redirect_to home_index_path
        end
      end

      context 'when user is developer' do
        before do
          sign_in user_dev
          get projects_path
        end

        it 'returns index page' do
          expect(response).to be_successful
        end
      end
    end

    describe 'GET #New' do
      context 'when user authenticated' do
        before do
          sign_in user
          get new_project_path
        end

        it 'returns new page' do
          expect(response).to be_successful
        end
      end

      context 'when user is not authorized' do
        before do
          sign_in user_dev
          get new_project_path
        end

        it 'returns unsuccessful' do
          expect(response).not_to be_successful
        end
      end

      context 'when user quality assurance' do
        before do
          sign_in user_qa
          get new_project_path
        end

        it 'returns unsuccessful' do
          expect(response).not_to be_successful
        end
      end
    end

    describe 'POST #Create' do
      context 'when user is authorized' do
        let(:project_params) { attributes_for(:project, creator_id: user.id) }

        before do
          sign_in user
          post projects_path(project: project_params)
        end

        it 'retuerns project' do
          # expect(flash[:notice]).to match(/Project Created Successfully*/)
          expect(response).to redirect_to(described_class.last)
        end
      end

      context 'when user unauthroized' do
        let(:project_params) { attributes_for(:project, creator_id: user_dev.id) }

        before do
          sign_in user_dev
          post projects_path(project: project_params)
        end

        it 'returns unsuccessful' do
          expect(response).not_to be_successful
        end
      end

      context 'when attribute not unique Unsuccessfull' do
        let(:project_params) do
          {
            title: 'hello',
            creator_id: user.id
          }
        end

        before do
          sign_in user
          post projects_path(project: project_params)
        end

        it 'returns new' do
          assert_template(:new)
        end
      end
    end

    describe 'GET #Show' do
      context 'when user is authorized' do
        before do
          sign_in user
        end

        it 'returns show page' do
          get project_path(project)
          expect(response).to be_successful
        end

        it 'returns unsuccessful sith dummy id' do
          get project_path(1234)
          expect(response).not_to be_successful
        end
      end

      context 'when user is unauthorized' do
        before do
          sign_in user_dev
        end

        it 'returns not authorized' do
          get project_path(project)
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'GET #Edit' do
      context 'when user is authorized' do
        before do
          sign_in user
        end

        it 'returns edit page' do
          get edit_project_path(project)
          expect(response).to be_successful
        end

        it 'returns unsuccessful' do
          get edit_project_path(1234)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user is Unauthorized' do
        before do
          sign_in user_dev
          get edit_project_path(project)
        end

        it 'returns unsuccessful' do
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'PATCH #Update' do
      context 'when user is authorized' do
        before do
          sign_in user
        end

        it 'returns project' do
          patch project_path(project), params: { project: { title: 'qwerty', new_user_ids: [17],
                                                            removable_user_ids: [] } }
          expect(response).to redirect_to(project)
        end

        it 'returns update page' do
          patch project_path(project), params: { project: { title: 'hello', new_user_ids: [], removable_user_ids: [] } }
          assert_template(:edit)
        end

        it 'returns not found' do
          patch project_path(1234), params: { project: { title: 'buggy', new_user_ids: [], removable_user_ids: [] } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user is unauthorized' do
        before do
          sign_in user_dev
        end

        it 'returns unsuccessful' do
          patch project_path(project), params: { project: { title: 'hello', new_user_ids: [], removable_user_ids: [] } }
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'DELETE #Destroy' do
      context 'when DELETE record' do
        before do
          sign_in user
        end

        it 'returns deletion successful' do
          delete project_path(project)
          expect(response).to redirect_to(projects_path)
        end

        it 'returns deletion Unsuccessful' do
          delete project_path(100)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
