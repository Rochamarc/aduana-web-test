require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'table fields' do 
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:auth_token).of_type(:string) }
     
  end

  context 'table indexes' do 
    it { is_expected.to have_db_index(:email) }
    it { is_expected.to have_db_index(:reset_password_token) }
    it { is_expected.to have_db_index(:auth_token) }
  end

  describe '#generate_authentication_token!' do 
    it 'generates a unique auth token' do 
      allow(Devise).to receive(:friendly_token).and_return('aabbccddeeff')
      user.generate_authentication_token!
      
      expect(user.auth_token).to eq('aabbccddeeff')
    end

    it 'generates another auth token when the current auth token already has been taken' do 
      allow(Devise).to receive(:friendly_token).and_return('aabbccdd1122','aabbccdd1122','aa22eeddff')
      existing_user = create(:user)      
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
