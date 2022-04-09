class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]
  include Paginable

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def create
    article = Article.new(article_params)
    if article.valid?
      # create article
    else
      render json: { "errors": errors(article) }, status: :unprocessable_entity
    end
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  end

  def serializer
    ArticleSerializer
  end

  private

  def article_params
    ActionController::Parameters.new
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
