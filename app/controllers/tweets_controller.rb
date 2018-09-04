class TweetsController < ApplicationController
  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end



  get  '/tweets/new' do
    if logged_in?
      @user = User.find_by(:id=>session[:user_id])
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if !params[:content].empty?
      tweet = Tweet.create(:content=>params[:content], :user_id=>session[:user_id])
    else
      redirect to "/tweets/new"
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by(:id => params[:id])
      if @tweet && @tweet.user == current_user
        erb :'tweets/edit_tweet'
      else
        redirect to "/tweets"
      end
    else
      redirect to "/login"
    end
  end

  get '/tweets/:id/delete' do
    if logged_in?

      @tweet = Tweet.find_by(:id => params[:id])
      if @tweet && @tweet.user == current_user
        binding.pry
        @tweet.delete
      end
      redirect to "/tweets"
    else
      redirect to "/login"
    end
  end

  get '/tweets/:id' do

    if logged_in?
      @tweet = Tweet.find_by(:id => params[:id])
      if @tweet
        erb :'tweets/show_tweet'
      else
        redirect to "/tweets"
      end

    else
      redirect to "/login"
    end
  end

  patch '/tweets/:id' do
    if logged_in?
      if params[:content] == ""

        redirect to "/tweets/#{params[:id]}/edit"
      else
        @tweet = Tweet.find_by(:id => params[:id])

        if @tweet && @tweet.user == current_user
          # if @tweet.update(:content=>params[:content])
          #   redirect to "/tweets/#{@tweet.id}"
          # else
            @tweet.update(:content => params[:content])
            redirect to "/tweets/#{@tweet.id}/edit"

        else
          redirect to "/tweets"
        end
      end
    else
      redirect to "/login"
    end
  end

  delete '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by(:id => params[:id])
      if @tweet && @tweet.user == current_user
        @tweet.delete
        redirect to '/tweets'
      else
        redirect to '/tweets/:id'
      end
    else
      redirect '/login'
    end
  end
end
