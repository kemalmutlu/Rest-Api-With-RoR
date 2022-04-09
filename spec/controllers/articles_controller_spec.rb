require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns a proper JSON' do
      article = create :article
      get :index
      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq('article')
        expect(expected[:attributes]).to eq(
                                           title: article.title,
                                           content: article.content,
                                           slug: article.slug)
      end
    end

    it 'paginates results' do
      article1, article2, article3 = create_list(:article, 3)
      get :index, params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2.id.to_s)
    end

    it 'contains pagination links in the response' do
      article1, article2, article3 = create_list(:article, 3)
      get :index, params: { page: { number: 2, size: 1 } }
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(
                                     :first, :prev, :next, :last, :self
                                   )
    end
  end

  describe 'GET #show' do
    let!(:article) { create(:article) }

    subject { get :show, params: { id: article.id } }

    before { subject }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns proper json' do

      aggregate_failures do
        expect(json_data[:id]).to eq(article.id.to_s)
        expect(json_data[:type]).to eq('article')
        expect(json_data[:attributes]).to eq(
                                            title: article.title,
                                            content: article.content,
                                            slug: article.slug,
                                          )
      end
    end
  end

  describe '#create' do
    subject { post :create }

    context 'when no code provided' do
      before { request.headers['authorization'] = "Invalid token" }
      it_behaves_like 'forbidden_request'
    end

    context 'when invalid code provided' do
      it_behaves_like 'forbidden_request'
    end
    context 'when authorized' do
      let(:access_token) { create :access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end
        subject { post :create, params: invalid_attributes }

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json[:errors]).to include(
                                     {
                                       source: { pointer: '/data/attributes/title' },
                                       detail: "can't be blank"
                                     },
                                     {
                                       source: { pointer: '/data/attributes/content' },
                                       detail: "can't be blank"
                                     },
                                     {
                                       source: { pointer: '/data/attributes/slug' },
                                       detail: "can't be blank"
                                     })
        end
      end
    end
  end
end