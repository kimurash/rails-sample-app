require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

    it 'returns the base title' do
      expect(full_title).to eq(base_title)
    end

    it 'returns the page title' do
      expect(full_title('Help')).to eq("Help | #{base_title}")
    end
  end
end
