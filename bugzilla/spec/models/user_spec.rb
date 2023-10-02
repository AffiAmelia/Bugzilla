# frozen_string_literal: true

require 'rails_helper'

DatabaseCleaner.cleaning do
  RSpec.describe User, type: :model do
    user = FactoryBot.create(:user)

    describe 'when association tests' do
      it { is_expected.to have_many(:project_users).dependent(:nullify) }
      it { is_expected.to have_many(:projects).through(:project_users) }
    end

    describe 'when validation tests' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:password) }
    end

    describe 'when column specifications' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:type).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
      it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
      it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    end

    describe '#name_with_email' do
      it 'checks if name_with_email are concatenated' do
        name_email = user.name_with_email
        expect(name_email).to eq("Name: #{user.name}  Email: #{user.email}")
      end
    end

    describe '#scopes' do
      it 'checks except_managers' do
        expect(described_class.except_managers).not_to include(user)
      end
    end

    describe 'validity of object' do
      it 'checks if the user is valid' do
        expect(user).to be_valid
      end

      it 'checks validity if name is null' do
        user = FactoryBot.build(:user, name: '')
        expect(user).to be_invalid
      end

      it 'checks validity if email is null' do
        user = FactoryBot.build(:user, email: '')
        expect(user).to be_invalid
      end

      it 'checks validity if email format is different' do
        user = FactoryBot.build(:user, email: Faker::String.random)
        expect(user).to be_invalid
      end

      it 'checks validity if password length is less then 6' do
        user = FactoryBot.build(:user, password: '1234')
        expect(user).to be_invalid
      end
    end
  end
end
