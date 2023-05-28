class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :login]

  def create
    user = User.find_by_email(registration_params[:email])
    if user
      render json: { message: 'User already exists.' }, status: 406
    else
      User.create!(registration_params)
      render json: { message: 'Successfully completed user registration.' }, status: 200
    end
  rescue => error
    Rails.logger.info "\nRegistration failed. Error: #{error.message}\n"
    render json: { message: 'Unable to complete user registration.' }, status: 422
  end

  def login
    @user = User.find_by_email(permitted_params[:email])
    if @user.blank?
      render json: { message: 'User not found.' }, status: 404
    elsif @user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { message: 'Successfully logged in.', token: token,
                     exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.full_name }, status: :ok
    else
      Rails.logger.info "\nElse block\n"
      render json: { error: 'Unauthorized.' }, status: :unauthorized
    end
  rescue => error
    Rails.logger.info "\nLog in failed. Error: #{error.message}\n"
    render json: { message: 'Unauthorized.' }, status: 422
  end

  private

  def registration_params
    params.permit(:admin_id, :user_type, :status, :full_name, :email, :phone_number, :profile_photo, :password, :password_confirmation)
  end

  def permitted_params
    params.permit(:admin_id, :user_type, :status, :full_name, :email, :phone_number, :profile_photo)
  end
end