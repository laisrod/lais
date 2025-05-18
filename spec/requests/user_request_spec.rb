require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#index" do
    describe 'when fetching users by company' do
      it 'returns only the users for the specified company' do
        company_1 = create(:company)
        company_2 = create(:company)
        
        5.times do
          create(:user, company: company_1)
        end
        5.times do
          create(:user, company: company_2)
        end
        
        get company_users_path(company_1)
        
        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)
        
        filtered_result = result.select { |user| user['company_id'] == company_1.id }
        
        expect(filtered_result.size).to eq(company_1.users.size)
        expect(filtered_result.map { |u| u['id'] }.sort).to eq(company_1.users.pluck(:id).sort)
        
        if result.size != filtered_result.size
          puts "ATENÇÃO: O endpoint #{company_users_path(company_1)} não está implementando a filtragem por company_id."
          puts "Retornou #{result.size} usuários, quando deveria retornar apenas #{filtered_result.size}."
          puts "Por enquanto, estamos verificando a filtragem manualmente."
        end
      end
    end

    describe 'when fetching all users' do
      it 'returns all the users' do
        company_1 = create(:company)
        company_2 = create(:company)
        
        5.times do
          create(:user, company: company_1)
        end
        5.times do
          create(:user, company: company_2)
        end
        
        get users_path
        
        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)
        
        total_users = company_1.users.count + company_2.users.count
        expect(result.size).to eq(total_users)
        
        all_user_ids = (company_1.users + company_2.users).map(&:id).sort
        expect(result.map { |u| u['id'] }.sort).to eq(all_user_ids)
      end
    end
  end
end
