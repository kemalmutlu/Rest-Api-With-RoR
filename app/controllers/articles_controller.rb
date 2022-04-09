class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]
  include Paginable

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def create
    article = current_user.articles.build(article_params)
    article.save!
    render json: serializer.new(article), status: :created
  rescue
    render json: { "errors": errors(article) }, status: :unprocessable_entity
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  end

  def update
    article = current_user.articles.find(params[:id])
    article.update!(article_params)
    render json: serializer.new(article), status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render json: { "errors": errors(article) }, status: :unprocessable_entity
  end

  def serializer
    ArticleSerializer
  end

  private

  def article_params
    params.require(:data).require(:attributes).permit(:title, :content, :slug) || ActionController::Parameters.new
  end

  def errors(article)
    errors = []
    article.errors.messages.each do |attr, msg|
      errors << {
        source: { pointer: "/data/attributes/#{attr.to_s}" },
        detail: msg.join
      }
    end
    errors
  end
end
