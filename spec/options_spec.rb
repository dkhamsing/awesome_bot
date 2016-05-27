require 'awesome_bot'

describe AwesomeBot do
  describe "options" do
    context "given duped link with --allow-dupe" do
      r = AwesomeBot::check 'https://github.com/dkhamsing https://github.com/dkhamsing'
      expected = 0
      value = r.statuses_issues.count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "options" do
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

  describe "options" do
    context "given a redirected link with --allow-redirect" do
      r = AwesomeBot::check 'http://github.com'
      expected = 0

      options = {
        'redirect'=>true,
        'ssl'=>false,
        'timeout'=>false
      }
      value = r.statuses_issues(options).count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "options" do
    context "given problem links with --allow-redirect and --allow-dupe" do
      options = {'whitelist'=>['github']}
      r = AwesomeBot::check 'http://github.com http://www.apple.com/ http://www.apple.com/', options
      expected = 0

      options = {
        'redirect'=>true,
        'ssl'=>false,
        'timeout'=>false
      }
      value = r.statuses_issues(options).count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end
end
