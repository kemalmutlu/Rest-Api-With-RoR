class ApplicationController < ActionController::API
  include JsonapiErrorsHandler

  ErrorMapper.map_errors!(
    'ActiveRecord::RecordNotFound' =>
      'JsonapiErrorsHandler::Errors::NotFound'
  )
  rescue_from ::StandardError, with: ->(e) { handle_error(e) }
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  private

  def authentication_error
    error =
      {
        status: '401',
        source: { pointer: '/code' },
        title: 'Authentication code is invalid',
        detail: 'You must provide a valid code in order to exchange it for token'
      }
    render json: { "errors": [error] }, status: 401
  end
end