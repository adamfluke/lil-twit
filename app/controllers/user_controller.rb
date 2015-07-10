get '/users/new' do
  p "hello"
  erb :'users/new'
end

get '/users/:id/timeline' do
  @user = User.find(params[:id])
  # @tweets = @user.tweets.reverse_order
  unless @user == current_user
    erb :user_error
  else
    erb :'users/user_timeline'
  end
end

get '/users/:id' do
  begin
    @user = User.find(params[:id])
  rescue => e
    return erb :'users/user_error'
  end

  if @user == current_user
    erb :'users/user_private'
  else
    erb :'users/user_public'
  end
end

# create
post '/users' do
  begin
    @user = User.create!(username: params[:username],
              password: params[:password],
              first_name: params[:first_name],
              last_name: params[:last_name],
              email: params[:email],
              city: params[:city],
              state: params[:state]
              )
    # return redirect '/' if @user.id.nil?
  rescue ActiveRecord::RecordInvalid => invalid
      return erb :'users/validation_error'
  else
    log_in @user
    redirect "/users/#{@user.id}/timeline"
  end
end

# read
get '/users' do
  @users = User.all
  erb :'users/all_users'
end

#update
put '/users/:id' do
  @user = User.find(params[:id])
  p @user
  p "#"*30
  begin
    @user.update_attributes(
                first_name: params[:first_name],
                last_name: params[:last_name],
                email: params[:email],
                city: params[:city],
                state: params[:state]
                )
    @user.save
  rescue ActiveRecord::Invalid => invalid
    redirect "/users/#{params[:id]}"
  end
  redirect "/users/#{params[:id]}"
end

get '/users/:id/tweets' do
  redirect to "/users/#{params[:id]}"
end

#delete
delete '/users/:id' do
  @user = User.find(current_user.id)
  log_out # log user out and then delete them from database
  @user.delete_tweets
  User.destroy(@user.id)
  redirect '/'
end

post '/users/:id/tweets' do
  Tweet.create(user_id: params[:id], content: params[:content], original_tweet_id: params[:original_tweet_id])
  redirect "/users/#{params[:id]}/timeline"
end

# Followstuff

get '/users/:id/followers' do
  @user = User.find(params[:id])
  erb :'users/user_followers'
end

get '/users/:id/following' do
  @user = User.find(params[:id])
  erb :'users/user_following'
end

post '/users/:id/follow' do
  @user = User.find(params[:id])
  current_user.follow(@user)
  redirect "users/#{@user.id}"
end

post '/users/:id/unfollow' do
  @user = User.find(params[:id])
  current_user.unfollow(@user)
  redirect "users/#{@user.id}"
end

#delete all following and follower relationships when we delete a user
#add retweet icon toggle button, add retweet count next to button
#make a pretty failure page if user doesn't exist

#on the user page, add following count for users

#show a random person to follow











