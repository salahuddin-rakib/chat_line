class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'URL not found' }, status: 404
  end

  def authorize_request
    auth_token = AuthToken.find_by!(token: bearer_token)
    if auth_token.present? && !auth_token.is_expired? && auth_token.user&.active?
      @current_user = auth_token.user
    else
      render json: { errors: 'Unauthorized.' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound => error
    render json: { errors: error.message }, status: :unauthorized
  rescue StandardError => error
    render json: { errors: error.message }, status: :unauthorized
  end

  private

  def bearer_token
    request.headers.fetch('Authorization', '').split(' ').last
  end
end
