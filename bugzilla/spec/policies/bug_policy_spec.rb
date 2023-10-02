# frozen_string_literal: true

require 'rails_helper'
DatabaseCleaner.cleaning do
  describe BugPolicy do
    subject { described_class.new(user, bug) }

    context 'when user is Manager' do
      let(:user) { FactoryBot.create(:user) }
      let(:bug) { FactoryBot.create(:bug, project_id: 293, creator_id: 3) }

      it { is_expected.to forbid_actions(%i[new create edit update destroy]) }
    end

    context 'when user is Developer' do
      let(:user) { FactoryBot.create(:user, type: 'Developer') }
      let(:bug) { FactoryBot.create(:bug, project_id: 293, creator_id: 3) }

      it { is_expected.to permit_action(:update) }
      it { is_expected.to forbid_actions(%i[new create edit destroy]) }
    end

    context 'when user is QA' do
      let(:user) { FactoryBot.create(:user, type: 'QualityAssurance') }
      let(:bug) { FactoryBot.create(:bug, project_id: 293, creator_id: 3) }

      it { is_expected.to permit_actions(%i[new create edit update destroy]) }
    end
  end
end
