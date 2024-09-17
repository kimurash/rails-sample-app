require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:activation_token) { User.new_token }
    let(:user) { FactoryBot.create(:michael) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'is sent with the subject "Account activation"' do
      expect(mail.subject).to eq('Account activation')
    end

    it 'is sent to the correct recipient' do
      expect(mail.to).to eq([user.email])
    end

    it 'is sent from the correct sender' do
      expect(mail.from).to eq([ENV['EMAIL_ADDRESS']])
    end

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
end
