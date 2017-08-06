require 'awesome_bot'

describe AwesomeBot do
  describe "white list" do
    context "given a white listed item" do
      item = 'google'
      list = [item,'yahoo']
      value = AwesomeBot::whitelisted list, item
      expected = true
      it "returns true" do
        expect(value).to eql(expected)
      end
    end
  end
end
