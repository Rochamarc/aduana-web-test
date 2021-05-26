class PostsController < ApplicationController
    before_action :authenticate_with_token!

    def index 
        @posts = current_user.posts    
        render json: { posts: @posts }, status: 200
    end

    def show 
        @posts = current_user.posts.find(params[:id])
        render json: @posts, status: 200
    end

    def create 
        @post = current_user.posts.build(post_params)

        if @post.save 
            render json: @post, status: 201 
        else
            render json: { errors: @post.errors }, status: 422
        end
    end

    def update 
        @post = current_user.posts.find(params[:id])
        
        if @post.update(post_params)
            render json: @post, status: 200
        else
            render json: { errors: @post.errors }, status: 422
        end
    end

    def destroy 
        @post = current_user.posts.find(params[:id])

        @post.destroy
        head 204
    end

    private 

    def post_params
        params.require(:post).permit(:title, :body)
    end
end