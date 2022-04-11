class AccessTokensController < ApplicationController
  skip_before_action :authorize!, only: :create

  def create
    authenticator = UserAuthenticator.new(authentication_params)
    authenticator.perform
    result = serializer.new(authenticator.access_token)
    render json: result, status: :created
  end

  def destroy
    current_user.access_token.destroy
  end

  def serializer
    AccessTokenSerializer
  end

  private

  def authentication_params
    params.permit(:code).to_h.symbolize_keys
  end
end