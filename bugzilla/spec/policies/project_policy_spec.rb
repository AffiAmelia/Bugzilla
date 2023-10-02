# frozen_string_literal: true

require 'rails_helper'
DatabaseCleaner.cleaning do
  describe ProjectPolicy do
    subject { described_class.new(user, project) }

    context 'when user is Manager' do
      let(:user) { FactoryBot.create(:user) }
      let(:project) { FactoryBot.create(:project, creator_id: user.id) }

      it { is_expected.to permit_actions(%i[index new create edit update destroy show]) }
    end

    context 'when user is Developer' do
      let(:user) { FactoryBot.create(:user, type: 'Developer') }
      let(:project) { FactoryBot.create(:project, creator_id: 14) }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to forbid_actions(%i[new edit update destroy show]) }
    end

    context 'when user is QA' do
      let(:user) { FactoryBot.create(:user, type: 'QualityAssurance') }
      let(:project) { FactoryBot.create(:project, creator_id: 14) }

      it { is_expected.to permit_actions(%i[index show]) }
      it { is_expected.to forbid_actions(%i[new edit update destroy]) }
    end
  end
end
