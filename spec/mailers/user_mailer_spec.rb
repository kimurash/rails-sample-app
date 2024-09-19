require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:michael) }

  describe 'account_activation' do
    let(:mail) { UserMailer.account_activation(user) }

    before do
      user.activation_token = User.new_token
    end

    # 件名
    it 'is sent with the subject "Account activation"' do
      expect(mail.subject).to eq('Account activation')
    end

    # 宛先
    it 'is sent to the correct recipient' do
      expect(mail.to).to eq([user.email])
    end

    # 送信元
    it 'is sent from the correct sender' do
      expect(mail.from).to eq([ENV['EMAIL_ADDRESS']])
    end

    # ======= 本文 =======

    it 'contains the user name in the email body' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'contains the user activation token in the email body' do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it 'contains the user email in the email body' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    # 件名
    it 'is sent with the subject "Password reset"' do
      expect(mail.subject).to eq('Password reset')
    end

    # 宛先
    it 'is sent to the correct recipient' do
      expect(mail.to).to eq([user.email])
    end

    # 送信元
    it 'is sent from the correct sender' do
      expect(mail.from).to eq([ENV['EMAIL_ADDRESS']])
    end

    # ======= 本文 =======

    it 'contains the user password reset token in the email body' do
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it 'contains the user email in the email body' do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
