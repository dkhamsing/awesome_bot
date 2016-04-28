require 'awesome_bot'

describe AwesomeBot do
  describe "white list" do
    context "given a white listed redirected link" do
      options = {'whitelist'=>['github']}
      r = AwesomeBot::check 'http://github.com', options
      expected = 0
      value = r.statuses_issues.count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "dupe" do
    context "given duped link with --allow-dupe" do
      r = AwesomeBot::check 'https://github.com/dkhamsing https://github.com/dkhamsing'
      expected = 0
      value = r.statuses_issues.count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "redirect" do
    context "given a redirected link" do
      r = AwesomeBot::check 'http://github.com'
      expected = 0
      value = r.statuses_issues(true).count
      it "has no issues with --allow-redirect" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "multiple options" do
    context "given problem links" do
      options = {'whitelist'=>['github']}
      r = AwesomeBot::check 'http://github.com http://www.apple.com/ http://www.apple.com/', options
      expected = 0
      value = r.statuses_issues(true).count
      it "has no issues with --allow-redirect and --allow-dupe" do
        expect(value).to eql(expected)
      end
    end
  end
end
