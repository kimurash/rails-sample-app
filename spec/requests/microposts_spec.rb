require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  # マイクロポスト投稿
  describe 'POST /microposts' do
    let(:user) { FactoryBot.create(:michael) }

    context 'when not logged in' do
      it 'does not create a micropost' do
        expect do
          post(
            microposts_path,
            params: { micropost: { content: 'Lorem ipsum' } }
          )
        end.to_not change(Micropost, :count)

        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to login_path
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
      end

      context 'with invalid submission' do
        it 'does not create a micropost' do
          expect do
            post(
              microposts_path,
              params: { micropost: { content: '' } }
            )
          end.to_not change(Micropost, :count)
        end

        it 'renders home page' do
          post(
            microposts_path,
            params: { micropost: { content: '' } }
          )
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template('static_pages/home')
        end
      end

      context 'with valid submission' do
        it 'creates a micropost' do
          expect do
            post(
              microposts_path,
              params: { micropost: { content: 'Lorem ipsum' } }
            )
          end.to change(Micropost, :count).by(1)
        end

        it 'redirects to root_url' do
          post(
            microposts_path,
            params: { micropost: { content: 'Lorem ipsum' } }
          )
          expect(flash[:success]).to be_present
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  # マイクロポスト削除
  describe 'DELETE /microposts/:id' do
    before do
      @micropost = FactoryBot.create(:recent_post)
      @user = @micropost.user
    end

    context 'when not logged in' do
      it 'does not delete a micropost' do
        expect { delete micropost_path(@micropost) }.to_not change(Micropost, :count)
      end

      it 'redirects to login_url' do
        delete(micropost_path(@micropost))
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to login_path
      end
    end

    context 'when logged in as wrong user' do
      let(:other_user) { FactoryBot.create(:archer) }

      before do
        log_in_as(other_user)
      end

      it 'does not delete a micropost' do
        expect { delete micropost_path(@micropost) }.to_not change(Micropost, :count)
      end

      it 'redirects to root_url' do
        delete(micropost_path(@micropost))
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to root_path
      end
    end

    context 'when logged in as correct user' do
      before do
        log_in_as(@user)
      end

      it 'deletes a micropost' do
        expect { delete micropost_path(@micropost) }.to change(Micropost, :count).by(-1)
      end

      it 'redirects to root_url' do
        delete(micropost_path(@micropost))
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to root_path
      end
    end
  end
end
