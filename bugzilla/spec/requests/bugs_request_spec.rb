# frozen_string_literal: true

require 'rails_helper'
DatabaseCleaner.cleaning do
  RSpec.describe Bug, type: :request do
    let(:user) { FactoryBot.create(:user) }
    let(:user_qa) { FactoryBot.create(:user, type: 'QualityAssurance') }
    let(:user_dev) { FactoryBot.build(:user, type: 'Developer') }
    let(:project) { FactoryBot.create(:project, creator_id: user.id) }
    let(:bug) { FactoryBot.create(:bug, project: project, creator_id: user_qa.id) }

    describe 'GET #New' do
      context 'when user authenticated GET #New' do
        before do
          sign_in user_qa
          get new_bug_path
        end

        it 'returns new page' do
          expect(response).to be_successful
        end
      end

      context 'when user unauthenticated GET #New' do
        before do
          get new_bug_path
        end

        it 'does not return new page' do
          expect(response).to redirect_to home_index_path
        end
      end

      context 'when user is Unauthorized GET #New' do
        before do
          sign_in user_dev
          get new_bug_path
        end

        it 'does not return new page' do
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'POST #Create' do
      let(:user_qa) do
        User.create(name: 'zoha', email: 'zj@gmail.com',
                    password: '123456', type: 'QualityAssurance')
      end

      context 'when user is authorized' do
        before do
          sign_in user_qa
          bug_params = attributes_for(:bug, project_id: project)
          post bugs_path(bug: bug_params)
        end

        it 'returns creation successful' do
          expect(response).to redirect_to(project_path(project))
        end
      end

      context 'when user is Unauthorized' do
        before do
          sign_in user
          bug_params = attributes_for(:bug, project_id: project)
          post bugs_path(bug: bug_params)
        end

        it 'returns creation Unsuccessful' do
          expect(response).not_to be_successful
        end
      end

      context 'when user is Unauthenticated' do
        before do
          bug_params = attributes_for(:bug, project_id: project)
          post bugs_path(bug: bug_params)
        end

        it 'returns creation Unsuccessful' do
          expect(response).to redirect_to home_index_path
        end
      end
    end

    describe 'GET #Show' do
      context 'when user is authorized' do
        before do
          sign_in user_qa
        end

        it 'returns show page' do
          get bug_path(bug)
          expect(response).to redirect_to(project_path(bug.project))
        end

        it 'returns unsuccessful with dummy id' do
          get bug_path(1111)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user is Unauthenticated' do
        before do
          get bug_path(bug)
        end

        it 'returns home' do
          expect(response).to redirect_to home_index_path
        end
      end
    end

    describe 'GET #Edit' do
      context 'when user is authorized' do
        before do
          sign_in user_qa
        end

        it 'returns edit page' do
          get edit_bug_path(bug)
          expect(response).to be_successful
        end

        it 'returns unsuccessful with dummy id' do
          get edit_bug_path(1234)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user is Unauthorized' do
        before do
          sign_in user
          get edit_bug_path(bug)
        end

        it 'returns unsuccessful' do
          expect(response).not_to be_successful
        end
      end
    end

    describe 'PATCH #Update' do
      before do
        sign_in user_qa
      end

      context 'when user is authorized' do
        it 'returns update successful' do
          patch bug_path(bug), params: { bug: attributes_for(:bug) }
          expect(response).to redirect_to(project_path(bug.project))
        end

        it 'returns update Unsuccessful with dummy id' do
          patch bug_path(1234), params: { bug: attributes_for(:bug) }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user is authorized Unsuccessful' do
        it 'returns update successful' do
          patch bug_path(bug), params: { bug: { title: '' } }
          assert_template(:edit)
        end
      end

      context 'when user is Developer Update status' do
        before do
          sign_in user_dev
          patch bug_path(bug), params: { bug: { status: 'started' } }
        end

        it 'returns update successful' do
          expect(response).to redirect_to(project_path(bug.project))
        end
      end

      context 'when user is unauthroized' do
        before do
          sign_in user
          patch bug_path(bug), params: { bug: attributes_for(:bug) }
        end

        it 'returns update Unsuccessful' do
          expect(response).not_to be_successful
        end
      end
    end

    describe 'DELETE #Destroy' do
      context 'when authroized' do
        before do
          sign_in user_qa
        end

        it 'returns deletion successful' do
          delete bug_path(bug)
          expect(response).to redirect_to(projects_path)
        end

        it 'returns deletion unsuccessful with dummy id' do
          delete bug_path(1234)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when Unauthroized' do
        before do
          sign_in user
        end

        it 'returns unsuccessful' do
          delete bug_path(bug)
          expect(response).not_to be_successful
        end
      end
    end
  end
end
