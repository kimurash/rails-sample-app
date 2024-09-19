require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'POST /relationships' do
    let(:user) { FactoryBot.create(:michael) }
    let(:other_user) { FactoryBot.create(:archer) }

    context 'when not logged in' do
      it 'redirects to the login page' do
        post relationships_path
        expect(response).to redirect_to login_url
      end

      it 'does not create a relationship' do
        expect do
          post relationships_path
        end.not_to change(Relationship, :count)
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
      end

      it 'creates a relationship the standard way' do
        expect do
          post(
            relationships_path,
            params: { followed_id: other_user.id }
          )
        end.to change(user.following, :count).by(1)
      end

      it 'creates a relationship with Hotwire' do
        expect do
          post(
            relationships_path(format: :turbo_stream),
            params: { followed_id: other_user.id }
          )
        end.to change(user.following, :count).by(1)
      end
    end
  end

  describe 'DELETE /relationships/:id' do
    let(:user) { FactoryBot.create(:michael) }
    let(:other_user) { FactoryBot.create(:archer) }

    before do
      log_in_as(user)
      user.follow(other_user)
      @relationship = user.active_relationships.find_by(followed_id: other_user.id)
    end

    it 'redirects to user page' do
      delete relationship_path(@relationship)
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to user_path(other_user)
    end

    it 'deletes the relationship the standard way' do
      expect do
        delete relationship_path(@relationship)
      end.to change(user.following, :count).by(-1)
    end

    it 'deletes the relationship with Hotwire' do
      log_in_as(user)
      expect do
        delete relationship_path(@relationship, format: :turbo_stream)
      end.to change(user.following, :count).by(-1)
    end
  end
end
