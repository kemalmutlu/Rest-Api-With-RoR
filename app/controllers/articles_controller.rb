class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]
  include Paginable

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def create
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  end

  def serializer
    ArticleSerializer
  end
end
