class UsersController < ApplicationController

  def index
    users = User
              .by_company(search_params[:company_identifier])
              .by_username(search_params[:username])
    render json: users.all
  end

  def send_welcome_email
    user = User.find(params[:id])
    UserMailer.welcome_email(user).deliver_now
    redirect_to user.company, notice: 'E-mail de boas-vindas enviado'
  end

  private

  def search_params
    params.permit(:username, :company_identifier)
  end

end
