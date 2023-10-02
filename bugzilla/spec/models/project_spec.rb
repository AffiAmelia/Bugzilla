# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'
DatabaseCleaner.cleaning do
  RSpec.describe Project, type: :model do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, creator_id: user.id)

    describe 'when association tests' do
      it { is_expected.to belong_to(:creator).class_name('Manager') }

      it { is_expected.to have_many(:bugs).dependent(:destroy) }
      it { is_expected.to have_many(:project_users).dependent(:nullify) }
      it { is_expected.to have_many(:users).through(:project_users) }
    end

    describe 'when validation tests' do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe 'when column specifications' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:string) }
      it { is_expected.to have_db_index(:title) }
    end

    describe 'validity of object' do
      it 'checks if project is valid' do
        expect(project).to be_valid
      end

      it 'checks validity if title is null' do
        project = FactoryBot.build(:project, title: '')
        expect(project).to be_invalid
      end

      it 'checks validity if creator is null' do
        project = FactoryBot.build(:project, creator_id: '')
        expect(project).to be_invalid
      end
    end
  end
end
