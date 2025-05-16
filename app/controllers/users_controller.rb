class UsersController < ApplicationController

  def index
    users = User
              .by_company(params[:company_identifier])
              .by_username(search_params[:username])
    render json: users.all
  end

  private

  def search_params
    params.permit(:username)
  end

end
