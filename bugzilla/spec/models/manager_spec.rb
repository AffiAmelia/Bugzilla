# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'
DatabaseCleaner.cleaning do
  RSpec.describe Manager, type: :model do
    describe 'when association tests' do
      it { is_expected.to have_many(:projects).dependent(:destroy) }
      it { is_expected.to have_many(:projects).with_foreign_key('creator_id') }
    end
  end
end
