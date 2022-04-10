class ArticleSerializer
  include JSONAPI::Serializer
  attributes :title, :content, :slug
  has_many :comments
end
