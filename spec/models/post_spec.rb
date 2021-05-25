require 'rails_helper'

RSpec.describe Post, type: :model do
    let(:post) { build(:post) } 

    it { is_expected.to belong_to(:user) }

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user_id }

    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:body) }
    it { is_expected.to respond_to(:user_id) }

    context 'table fields' do 
        it { is_expected.to have_db_column(:title).of_type(:string) }
        it { is_expected.to have_db_column(:body).of_type(:text) }
        it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end

    context 'table indexes' do 
        it { is_expected.to have_db_index(:user_id) }
    end
end