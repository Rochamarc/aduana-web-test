require 'rails_helper'

RSpec.describe 'Users API', type: :request do 
    let(:user) { create(:user) } # create a user
    let(:user_id) { user.id } # get this users id
    let(:user_email ) { user.email }
    
    describe 'GET /users/:id' do 
        before do
            get "/users/#{user_id}"  
        end

        context "when user exists" do 
            it "returns the user" do 
                user_response = JSON.parse(response.body)    
                expect(user_response["id"]).to eq(user_id) # compare the user_id with the user_response_id
            end
            it "mathces the email" do
                user_response = JSON.parse(response.body)
                expect(user_response["email"]).to eq(user_email) 
            end
        end

        it "returns status 200" do 
            expect(response).to have_http_status(200)
        end
    end

    describe 'POST /users' do 
        before do
            post '/users', params: { user: user_params } 
        end

        context 'when the request params are valid' do
            let(:user_params) { attributes_for(:user) }

            it 'returns status code 201' do 
                expect(response).to have_http_status(201)
            end

            it 'returns json data for the created user' do
                user_response = JSON.parse(response.body)
                expect(user_response['email']).to eq(user_params[:email]) 
            end
        end

        context 'when the request params are invalid' do 
            let(:user_params) { attributes_for(:user, email: 'invalid_email') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns the json data for errors' do 
                user_response = JSON.parse(response.body)
                expect(user_response).to have_key('errors')
            end
        end
    end

    describe 'PUT /users/:id' do 
        before do 
            put "/users/#{user_id}", params: { user: user_params }
        end

        context 'when the requests params are valid' do
            let(:user_params) { { email: "new_email@email.com" } }

            it 'returns status code 200' do 
                expect(response).to have_http_status(200)
            end

            it 'returns the json data for the updated user' do 
                user_response = JSON.parse(response.body)
                expect(user_response['email']).to eq(user_params[:email])
            end
        end 

        context 'when the requests params are invalid' do 
            let(:user_params) { { email: 'invalid_email'} }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns the json data for errors' do 
                user_response = JSON.parse(response.body)
                expect(user_response).to have_key('errors')
            end
        end
    end

    describe 'DELETE /users/:id' do
        before do 
            delete "/users/#{user_id}"
        end

        it 'returns status code 204' do
            expect(response).to have_http_status(204)
        end
        
        it 'removes the user from the database' do 
            expect(User.find_by(id: user_id)).to be_nil 
        end
    end
end