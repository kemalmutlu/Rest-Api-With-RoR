class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    result = serializer.new(authenticator.access_token)
    render json: result, status: :created
  end

  def serializer
    AccessTokenSerializer
  end
end