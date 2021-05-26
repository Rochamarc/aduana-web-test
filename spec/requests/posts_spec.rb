require 'rails_helper'

RSpec.describe 'Post API' do 
    let(:user) { create(:user) }
    let(:headers) do {
        'Authorization' => user.auth_token
        }   
    end

    describe 'GET /posts' do
        before do
            create_list(:post, 5, user_id: user.id)
            get '/posts', params: {}, headers: headers 
        end

        it 'return status code 200' do 
            expect(response ).to have_http_status(200)
        end 

        it 'returns 5 posts from database' do
            json_body = JSON.parse(response.body) 
            expect(json_body['posts'].count).to eq(5)
        end

    end

    describe 'GET /posts/:id' do
        let(:post) { create(:post, user_id: user.id) }

        before { get "/posts/#{post.id}", params: {}, headers: headers }

        it 'return status code 200' do 
            expect(response).to have_http_status(200)
        end

        it 'return the json for post' do
            json_body = JSON.parse(response.body) 
            expect(json_body['title']).to eq(post.title)
        end
    end

    describe 'POST /posts' do
        before do
            post '/posts', params: { post: post_params }, headers: headers 
        end

        context 'when the parameters are valid' do 
            let(:post_params) { attributes_for(:post) }

            it 'returns status code 201' do 
                expect(response).to have_http_status(201)
            end

            it 'saves the post in the database' do 
                expect( Post.find_by(title: post_params[:title]) ).not_to be_nil
            end

            it 'return the json for created post' do 
                json_body = JSON.parse(response.body)
                expect(json_body['title']).to eq(post_params[:title])
            end

            it 'assigns the created post to the current user' do 
                json_body = JSON.parse(response.body)
                expect(json_body['user_id']).to eq(user.id)
            end
        end

        context 'when the parametes are invalid' do 
            let(:post_params) { attributes_for(:post, title: '') }

            it 'returns status code 422' do 
                expect(response).to have_http_status(422)
            end

            it 'does not save tha task in the database' do 
                expect( Post.find_by(title: post_params[:title]) ).to be_nil
            end

            it 'return the json erros for title' do 
                json_body = JSON.parse(response.body)
                expect(json_body['errors']).to have_key('title')
            end
        end
    end

    describe 'PUT /posts/:id' do 
        let(:post) { create(:post, user_id: user.id)}
        before do 
            put "/posts/#{post.id}", params: { post: post_params }, headers: headers 
        end

        context 'when the params are valid' do 
            let(:post_params) { { title: 'New post title' } }

            it 'returns status code 200' do 
                expect(response).to have_http_status(200)
            end

            it 'returns the json for the updated post' do 
                json_body = JSON.parse(response.body)
                expect(json_body['title']).to eq(post_params[:title])
            end

            it 'updates the post on the database' do
                expect( Post.find_by(title: post_params[:title]) ).not_to be_nil
            end
        end

        context 'when the params are invalid' do 
            let(:post_params) { { title: ' ' } }


            it 'returns status code 422' do 
                expect(response).to have_http_status(422)
            end

            it 'return the json error for title' do 
                json_body = JSON.parse(response.body)
                expect(json_body['errors']).to have_key('title')
            end

            it 'does not update the post on the database' do 
                expect( Post.find_by(title: post_params[:title]) ).to be_nil
            end
        end
    end

    describe 'DELETE /posts/:id' do 
        let(:post) { create(:post, user_id: user.id) }

        before do 
            delete "/posts/#{post.id}", params: {}, headers: headers 
        end

        it 'returns status code 204' do 
            expect(response).to have_http_status(204)
        end

        it 'removes the post from the database' do 
            expect { Post.find(post.id) }.to raise_error(ActiveRecord::RecordNotFound) 
        end
    end
end