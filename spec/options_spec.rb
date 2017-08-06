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
      options = {'white_list'=>['github']}
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
        'allow_redirect'=>true,
        'allow_ssl'=>false,
        'allow_timeout'=>false
      }
      value = r.statuses_issues(options).count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "options" do
    context "given a redirected link with --allow 301" do
      r = AwesomeBot::check 'http://github.com'
      expected = 0

      options = {
        AwesomeBot::CLI_OPT_ERRORS=>['301'],
        'allow_redirect'=>true,
        'allow_ssl'=>false,
        'allow_timeout'=>false
      }
      value = r.statuses_issues(options).count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "options" do
    context "given problem links with --allow-redirect and --allow-dupe" do
      options = {'white_list'=>['github']}
      r = AwesomeBot::check 'http://github.com http://www.apple.com/ http://www.apple.com/', options
      expected = 0

      options = {
        'allow_redirect'=>true,
        'allow_ssl'=>false,
        'allow_timeout'=>false
      }
      value = r.statuses_issues(options).count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end

  describe "options" do
    c = '[something] (https://www.yahoo.com/)'

    context "given only one markdown issue with --validate-markdown" do
      options = {'markdown'=>true}
      r = AwesomeBot::check c, options
      expected = 1
      value = r.validate.count
      it "has one issues" do
        expect(value).to eql(expected)
      end
    end

    context "given only one markdown issue without --validate-markdown" do
      r = AwesomeBot::check c
      expected = 0
      value = r.validate.count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end
  end
end
