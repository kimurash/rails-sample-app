require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup' do
    it 'returns OK' do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users' do
    let(:user) { FactoryBot.create(:michael) }

    context 'when not logged in' do
      before do
        get users_path
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe 'POST /users' do
    context 'with invalid information' do
      let(:user_params) do
        {
          user: { name: '', email: 'user@invalid', password: 'foo', password_confirmation: 'bar' }
        }
      end

      it 'does not create a user' do
        expect { post(users_path, params: user_params) }.to_not change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end

    context 'with valid information' do
      let(:user_params) do
        {
          user: { name: 'Example User', email: 'user@example.com',
                  password: 'password', password_confirmation: 'password' }
        }
      end

      before do
        ActionMailer::Base.deliveries.clear
      end

      it 'creates a user temporary' do
        expect { post(users_path, params: user_params) }.to change(User, :count).by(1)
        expect(flash[:info]).to be_present
        expect(response).to redirect_to root_url
      end

      it 'sends an activation email' do
        post(users_path, params: user_params)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end

      it 'does not activate the user' do
        post(users_path, params: user_params)
        expect(User.last.activated?).to be_falsey
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when user is inactive' do
      let(:inactive_user) { FactoryBot.create(:malory) }

      before do
        get user_path(inactive_user)
      end

      it 'redirects to the root page' do
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when user is activated' do
      let(:activated_user) { FactoryBot.create(:michael) }

      before do
        get user_path(activated_user)
      end

      it 'renders the user page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET /users/:id/edit' do
    let(:user) { FactoryBot.create(:michael) }

    context 'when not logged in' do
      before do
        get edit_user_path(user)
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(login_url)
      end

      it 'redirects to edit page after login' do
        log_in_as(user)
        expect(response).to redirect_to(edit_user_url(user))
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
        get edit_user_path(user)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when logged in as other user' do
      let(:other_user) { FactoryBot.create(:archer) }

      before do
        log_in_as(other_user)
        get edit_user_path(user)
      end

      it 'redirects to the root page' do
        expect(flash).to be_empty
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'PATCH /users/:id' do
    let(:user) { FactoryBot.create(:michael) }

    context 'when not logged in' do
      before do
        patch(
          user_path(user),
          params: {
            user: { name: user.name, email: user.email }
          }
        )
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when logged in' do
      before do
        log_in_as(user)
      end

      context 'with invalid information' do
        before do
          patch(
            user_path(user),
            params: {
              user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' }
            }
          )
        end

        it 'does not update the user' do
          user.reload
          expect(user.name).not_to eq('')
          expect(user.email).not_to eq('')
          expect(user.password).not_to eq('foo')
          expect(user.password_confirmation).not_to eq('bar')
        end

        it 'renders the edit page' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
        end
      end

      context 'with valid information' do
        let(:name) { 'Foo Bar' }
        let(:email) { 'foo@bar.com' }

        before do
          patch(
            user_path(user),
            params: {
              user: { name:, email:, password: '', password_confirmation: '' }
            }
          )
        end

        it 'updates the user' do
          user.reload
          expect(user.name).to eq(name)
          expect(user.email).to eq(email)
        end

        it 'redirects to the user page' do
          expect(flash[:success]).to be_present
          expect(response).to redirect_to(user)
        end
      end
    end

    context 'when logged in as other user' do
      let(:other_user) { FactoryBot.create(:archer) }

      before do
        log_in_as(other_user)
      end

      it 'cannnot update admin attribute' do
        expect(other_user.admin?).to be_falsey
        patch(
          user_path(other_user),
          params: {
            user: { password: '', password_confirmation: '', admin: true }
          }
        )
        other_user.reload
        expect(other_user.admin?).to be_falsey
      end

      context 'with valid information' do
        before do
          patch(
            user_path(user),
            params: {
              user: { name: user.name, email: user.email }
            }
          )
        end

        it 'redirects to the root page' do
          expect(flash).to be_empty
          expect(response).to have_http_status(:see_other)
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end

  describe 'DELETE /users/:id' do
    let!(:admin) { FactoryBot.create(:michael) }
    let!(:non_admin) { FactoryBot.create(:archer) }

    context 'when not logged in' do
      before do
        delete user_path(non_admin)
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when logged in as a non-admin user' do
      before do
        log_in_as(non_admin)
      end

      it 'does not delete the user' do
        expect { delete user_path(admin) }.to_not change(User, :count)
      end

      it 'redirects to the root page' do
        delete user_path(admin)
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when logged in as an admin user' do
      before do
        log_in_as(admin)
      end

      it 'deletes the user' do
        expect { delete user_path(non_admin) }.to change(User, :count).by(-1)
      end

      it 'redirects to the users page' do
        delete user_path(non_admin)
        expect(flash[:success]).to be_present
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(users_url)
      end
    end
  end
end
