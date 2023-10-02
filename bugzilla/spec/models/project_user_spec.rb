# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'
DatabaseCleaner.cleaning do
  RSpec.describe ProjectUser, type: :model do
    describe 'when association tests' do
      it { is_expected.to belong_to(:project) }
      it { is_expected.to belong_to(:user) }
    end
  end
end
