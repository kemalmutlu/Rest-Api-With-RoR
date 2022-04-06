class AccessTokenSerializer
  include JSONAPI::Serializer
  attributes :id, :token
end
