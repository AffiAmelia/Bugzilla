# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'
DatabaseCleaner.cleaning do
  RSpec.describe Bug, type: :model do
    user = FactoryBot.create(:user)
    user_qa = FactoryBot.create(:user, type: 'QualityAssurance')
    project = FactoryBot.create(:project, creator_id: user.id)
    bug = FactoryBot.create(:bug, project: project, creator_id: user_qa.id)

    describe 'when association tests' do
      it { is_expected.to belong_to(:project) }
      it { is_expected.to belong_to(:creator).class_name('QualityAssurance').inverse_of(:reported_bugs) }
      it { is_expected.to belong_to(:assignee).class_name('Developer').inverse_of(:assigned_bugs) }
    end

    describe 'when validation tests' do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to validate_presence_of(:status) }
      it { is_expected.to validate_presence_of(:deadline) }

      it { is_expected.to validate_uniqueness_of(:title).scoped_to(:project_id) }
    end

    describe 'when column specifications' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:string) }
      it { is_expected.to have_db_column(:category).of_type(:integer) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:deadline).of_type(:datetime) }
    end

    describe 'when enum defined' do
      it { is_expected.to define_enum_for(:category).with(bug: 0, feature: 1) }
      it { is_expected.to define_enum_for(:status).with(pending: 0, started: 1, completed: 2, resolved: 3) }
    end

    describe 'scrrenshot attach' do
      it 'screenshot valid' do
        bug.screenshot.attach(io: File.open('/Users/dev/Downloads/cloudinary.yml'), filename: 'cloudinary.yml')
        expect(bug).to be_invalid
      end

      it 'screenshot type Invalid' do
        bug.screenshot.attach(io: File.open('/Users/dev/Downloads/bug.gif'), filename: 'bug.gif')
        expect(bug).to be_valid
      end
    end

    describe 'validity of methods' do
      it 'checks possible_upcoming_statuses' do
        statuses = bug.possible_upcoming_statuses
        expect(statuses).to eq(Bug::BUG_STATUS_MAP.to_a)
      end
    end

    describe 'validity of object' do
      it 'checks if bug is valid' do
        expect(bug).to be_valid
      end

      it 'checks validity if title is null' do
        bug = FactoryBot.build(:bug, title: '')
        expect(bug).to be_invalid
      end

      it 'checks validity if status is null' do
        bug = FactoryBot.build(:bug, status: '')
        expect(bug).to be_invalid
      end

      it 'checks validity if category is null' do
        bug = FactoryBot.build(:bug, category: '')
        expect(bug).to be_invalid
      end

      it 'checks validity if deadline is null' do
        bug = FactoryBot.build(:bug, deadline: '')
        expect(bug).to be_invalid
      end

      it 'checks validity if project is null' do
        bug = FactoryBot.build(:bug, project_id: '')
        expect(bug).to be_invalid
      end

      it 'checks validity if creator is null' do
        bug = FactoryBot.build(:bug, creator_id: '')
        expect(bug).to be_invalid
      end
    end
  end
end
