# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'
DatabaseCleaner.cleaning do
  RSpec.describe QualityAssurance, type: :model do
    describe 'when association tests' do
      it { is_expected.to have_many(:reported_bugs).dependent(:destroy) }
      it { is_expected.to have_many(:reported_bugs).with_foreign_key('creator_id') }
    end
  end
end
