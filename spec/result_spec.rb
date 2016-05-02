require 'awesome_bot'

describe AwesomeBot do
  describe "result" do
    context "given a result" do
      r = AwesomeBot::check 'https://github.com/supermarin/Alcatraz'
      h = r.write_artifacts
      expected = 3
      value = h.keys.count
      it "has a json artifact" do
        expect(value).to eql(expected)
      end

      it "has a date key" do
        expect(h.keys).to include('date')
      end

      it "has a links key" do
        expect(h.keys).to include('links')
      end

      it "has a results key" do
        expect(h.keys).to include('results')
      end
    end
  end
end
