class UsersController < ApplicationController
    
  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else 
      erb :'users/new'
    end
  end

  post '/signup' do 
    if params[:username]=="" || params[:email]=="" || params[:password]==""
      redirect '/signup'
    end
    @user = User.create(username: params[:username], email: params[:email], password: params[:password])
    
    session[:user_id] = @user.id
    redirect "/tweets"
     
  end

  get '/login' do
      
      if logged_in?
        redirect to "/tweets"
      else 
        erb :'/users/login'
      end
  end

  post '/login' do
      @user = User.find_by(username: params[:username])
      if @user != nil && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect to "/tweets"
      end
      redirect to '/signup' if !logged_in? 
  end

  get '/logout' do
      if logged_in?
        session.clear
        redirect '/login'
      else
        redirect '/'
      end
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
end
