# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'
DatabaseCleaner.cleaning do
  RSpec.describe Developer, type: :model do
    describe 'when association tests' do
      it { is_expected.to have_many(:assigned_bugs).dependent(:nullify) }
      it { is_expected.to have_many(:assigned_bugs).with_foreign_key('assignee_id') }
    end
  end
end
