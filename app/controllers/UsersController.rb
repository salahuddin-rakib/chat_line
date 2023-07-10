class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :login]
  before_action :find_user, only: [:update, :messages]

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
      token = JsonWebToken.login_token_encode(@user)
      render json: { message: 'Successfully logged in.', token: token,
                     username: @user.full_name }, status: :ok
    else
      render json: { error: 'Unauthorized.' }, status: :unauthorized
    end
  rescue => error
    Rails.logger.info "\nLog in failed. Error: #{error.message}\n"
    render json: { message: 'Unauthorized.' }, status: 422
  end

  def index
    admin_user?
    users = User.customer.limit(10).map do |user|
      {
        id: user.id,
        full_name: user.full_name,
        status: user.status,
        user_type: user.user_type,
        email: user.email,
        phone_number: user.phone_number,
        message: user.messages.pluck(:message_text, :from_user_id).last || {},
      }
    end

    render json: { success: true, message: 'Successfully fetched users.', users: users }, status: :ok
  rescue => error
    Rails.logger.info "\nUnable to fetch users due to: #{error.message}\n"
    render json: { success: false, message: 'Unable to fetch users.' }, status: 200
  end

  def messages
    page = params.fetch(:page, 0).to_i
    limit = params.fetch(:limit, 10).to_i
    offset = page * limit

    messages = Message.where('from_user_id = :id OR to_user_id = :id', id: @user.id)
    messages = messages.limit(limit).offset(offset).map do |message|
      {
        id: message.id,
        text: message.message_text,
        sender: message.from_user&.full_name || '',
        sender_type: message.from_user&.user_type,
        sender_id: message.from_user_id,
      }
    end
    render json: { success: true, message: 'Successfully fetched messages.', messages: messages }, status: :ok
  rescue => error
    Rails.logger.info "\nUnable to fetch users due to: #{error.message}\n"
    render json: { success: false, message: 'Unable to fetch messages.' }, status: 200
  end

  def update
    admin_user?
    @user.update!(permitted_params)
    render json: { message: 'Successfully updated user.' }, status: :ok
  rescue => error
    Rails.logger.info "\nUnable to update user due to: #{error.message}\n"
    render json: { message: 'Unable to update user.' }, status: 422
  end

  private

  def registration_params
    params.permit(:admin_id, :user_type, :status, :full_name, :email, :phone_number, :profile_photo, :password, :password_confirmation)
  end

  def permitted_params
    params.permit(:admin_id, :user_type, :status, :full_name, :email, :phone_number, :profile_photo)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    unless @user
      render json: { message: 'User not found.' }, status: 404
    end
  end

  def admin_user?
    unless @current_user.admin?
      render json: { message: 'User is not an admin.' }, status: 406
    end
  end
end
