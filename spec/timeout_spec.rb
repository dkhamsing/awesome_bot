require 'awesome_bot'

describe AwesomeBot do
  describe "timeout" do
    timeoutlink = 'http://1.2.3.4'
    options = {'timeout'=>1}

    context "given a timeout link and setting timeout to 1s" do
      r = AwesomeBot::check timeoutlink, options
      s = r.statuses_issues[0]
      expected = 'timed out'
      value = s['error'].to_s
      it "has a timeout" do
        expect(value).to include(expected)
      end
    end

    context "given a timeout link and setting timeout to 1s with --allow-timeout" do
      r = AwesomeBot::check timeoutlink, options
      expected = 0

      options = {
        'redirect'=>false,
        'ssl'=>false,
        'timeout'=>true
      }
      value = r.statuses_issues(options).count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end
end
