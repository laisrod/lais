require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'scopes' do
    describe '.by_username' do
      it 'returns all users when no username is provided' do
        company = create(:company)
        user1 = create(:user, username: 'max_smith', company: company)
        user2 = create(:user, username: 'mathew_johnson', company: company)
        user3 = create(:user, username: 'John_Maxwell', company: company)
        user4 = create(:user, username: 'alexandra', company: company)
        
        expect(User.by_username(nil).count).to eq(4)
        expect(User.by_username('').count).to eq(4)
      end

      it 'finds matches at the beginning of the username' do
        company = create(:company)
        user1 = create(:user, username: 'max_smith', company: company)
        user2 = create(:user, username: 'mathew_johnson', company: company)
        user3 = create(:user, username: 'John_Maxwell', company: company)
        user4 = create(:user, username: 'alexandra', company: company)
        
        results = User.where("LOWER(username) LIKE LOWER(?)", "ma%")
        expect(results).to include(user1, user2)
        expect(results).not_to include(user3, user4)
      end

      it 'ignores case differences' do
        company = create(:company)
        user1 = create(:user, username: 'max_smith', company: company)
        user2 = create(:user, username: 'mathew_johnson', company: company)
        user3 = create(:user, username: 'John_Maxwell', company: company)
        user4 = create(:user, username: 'alexandra', company: company)
        
        results = User.by_username('MA')
        expect(results).to include(user1, user2)
        expect(results).not_to include(user4)

        results = User.by_username('mAx')
        expect(results).to include(user1, user3)
      end

      it 'returns empty set when there are no matches' do
        company = create(:company)
        user1 = create(:user, username: 'max_smith', company: company)
        user2 = create(:user, username: 'mathew_johnson', company: company)
        user3 = create(:user, username: 'John_Maxwell', company: company)
        user4 = create(:user, username: 'alexandra', company: company)
        
        results = User.by_username('xyz')
        expect(results).to be_empty
      end

      it 'finds matches in any part of the username' do
        company = create(:company)
        user1 = create(:user, username: 'max_smith', company: company)
        user2 = create(:user, username: 'mathew_johnson', company: company)
        user3 = create(:user, username: 'John_Maxwell', company: company)
        user4 = create(:user, username: 'alexandra', company: company)
        
        results = User.by_username('ma')
        expect(results).to include(user1, user2, user3)
        expect(results).not_to include(user4)
      end
    end
  end
end
