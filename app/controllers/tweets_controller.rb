class TweetsController < ApplicationController

 get '/tweets' do
    if logged_in?
        @tweets = Tweet.all 
        @user = current_user
        erb :'tweets/tweets'
    else
        redirect '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
        erb :'tweets/new'
    else
        redirect '/login'
    end
  end

  get '/tweets/:id/edit' do 
    @tweet = Tweet.find_by(id: params[:id])
    
    if logged_in? && current_user.username == @tweet.user.username 
        erb :'tweets/edit'
    else
        redirect to '/login'
    end
  end

  post '/tweets/:id' do 
    @tweet = Tweet.find_by(id: params[:id])
    @tweet.update(content: params[:content])
    if logged_in? && params[:content] != "" && current_user.username == @tweet.user.username 
        redirect to "/tweets/#{@tweet.id}"
    elsif
        redirect to "/tweets/#{@tweet.id}/edit"
    else
        redirect to '/login'
    end
  end

  get "/tweets/:id" do 
    @tweet = Tweet.find_by(id: params[:id])
    if logged_in?
        erb :'tweets/show'
    else
        redirect '/login'
    end
  end

  post '/tweets' do 
    if params[:content] == ""
        redirect to '/tweets/new'
    else
        @tweet = Tweet.create(content: params[:content])
        current_user.tweets << @tweet
        @tweet.save
        redirect "/tweets/#{@tweet.id}"
    end
  end

  patch '/tweets/:id' do 
    if params[:content] == ""
        redirect to "/tweets/#{params[:id]}/edit"
    else
        @tweet = Tweet.find_by(id: params[:id])
        @tweet.update(content: params[:content])
        @tweet.save 

        redirect to "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do 
    @tweet = Tweet.find_by(id: params[:id])
    if logged_in? && current_user.username == @tweet.user.username
        @tweet.delete
        redirect '/tweets'
    end
  end
end