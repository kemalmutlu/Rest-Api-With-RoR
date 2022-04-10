class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]
  before_action :load_article
  include Paginable

  def index
    comments = paginate(@article.comments)
    render_collection(comments)
  end

  def create
    @comment = @article.comments.build(
      comment_params.merge(user: current_user)
    )

    @comment.save!

    render json: serializer.new(@comment), status: :created, location: @article
  rescue
    render json: { "errors": attribute_errors(@comment) }, status: :unprocessable_entity
  end

  def serializer
    CommentSerializer
  end

  private

  def load_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:data).require(:attributes).
      permit(:content) ||
      ActionController::Parameters.new
  end
end