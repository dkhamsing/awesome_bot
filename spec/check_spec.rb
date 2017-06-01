require 'awesome_bot'

describe AwesomeBot do
  describe "check" do
    context "given 2 dupes" do
      it "returns 2" do
        dupes = %(
          https://github.com
          https://github.com
        )
        expect(AwesomeBot::check(dupes).dupes.count).to eql(2)
      end
    end

    nodupes = %(
      1. https://twitter.com
      2. http://github.com
      3. https://github.com
    )

    context "given no dupes" do
      it "returns 0" do
        expect(AwesomeBot::check(nodupes).dupes.count).to eql(0)
      end
    end

    context "given 3 links" do
      it "returns 3" do
        expect(AwesomeBot::check(nodupes).status.count).to eql(3)
      end
    end

    context "given a bad link" do
      bad = 'http://localhost:11029 bad'
      r = AwesomeBot::check(bad)
      item = r.statuses_issues[0]

      error = item['error']
      it "returns an error" do
        expect(error).not_to eql(nil)
      end

      status = item['status']
      it "has a status of -1" do
        expect(status).to eql(-1)
      end
    end

    context "given a redirect" do
      link = 'http://google.com redirect'
      r = AwesomeBot::check(link)
      item = r.statuses_issues[0]
      redirect = item['headers']['location']
      expected = 'http://www.google.com/'
      it "has a redirect" do
        expect(redirect).to eql(expected)
      end
    end

    context "given 2 links with basic-auth embedded" do
      content = %(
        http://user:passwd@httpbin.org/basic-auth/user/passwd
        http://user:badpasswd@httpbin.org/basic-auth/user/passwd
      )
      r = AwesomeBot::check content

      it "returns 2 status results" do
        expect(r.status.count).to eql(2)
      end

      it "good password has no issues" do
        expect(r.status[0]['status']).to eql(200)
      end

      it "bad password has issue" do
        expect(r.status[1]['status']).to eql(401)
      end

      it "has one issue overall" do
        expect(r.statuses_issues.count).to eql(1)
      end
    end

    context "given links, one with issue" do
      content = %(
        https://twitter.com
        http://github.com
      )
      r = AwesomeBot::check content

      expected = 1
      value = r.statuses_issues.count
      it "has one issue" do
        expect(value).to eql(expected)
      end

      expected = 0
      value = r.dupes.count
      it "has no dupes" do
        expect(value).to eql(expected)
      end
    end

    context "given links with no issues" do
      content = %(
        https://www.nytimes.com/
        https://github.com/
      )
      r = AwesomeBot::check content

      expected = 0
      value = r.statuses_issues.count
      it "has no issues" do
        expect(value).to eql(expected)
      end
    end

    context "given no links" do
      r = AwesomeBot::check 'blah blah no links'
      expected = 0
      value = r.status.count
      it "has no links" do
        expect(value).to eql(expected)
      end
    end
  end
end
