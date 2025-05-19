class TweetsController < ApplicationController
  def index
    tweets = Tweet.paginate(
      cursor: params[:cursor],
      user_id: params[:user_id],
      limit: 10
    )
    
    render json: tweets
  end
end
