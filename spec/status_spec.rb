require 'awesome_bot'

describe AwesomeBot do
  describe "status" do
    context "given a redirect" do
      r = AwesomeBot::check 'https://github.com/supermarin/Alcatraz redirect'
      s = r.status[0]
      value = s['status']
      expected = 301
      it "has a #{expected} status" do
        expect(value).to eql(expected)
      end
    end

    context "given an ok link" do
      r = AwesomeBot::check 'https://github.com/dkhamsing ok'
      s = r.status[0]
      value = s['status']
      expected = 200
      it "has a #{expected} status" do
        expect(value).to eql(expected)
      end
    end

    context "given an invalid link" do
      r = AwesomeBot::check 'https://github.com/dkhamsing/badddddd bad'
      s = r.status[0]
      value = s['status']
      expected = 404
      it "has a #{expected} status" do
        expect(value).to eql(expected)
      end
    end

    context "given an uncommon link" do
      r = AwesomeBot::check 'http://httpstat.us/503 other'
      s = r.status[0]
      value = s['status']
      expected = 200
      it "has a status different from #{expected}" do
        expect(value).to_not eql(expected)
      end
    end

    context "given a problematic link" do
      link = 'https://developer.apple.com/testflight/ '
      r = AwesomeBot::check link
      s = r.status[0]
      value = s['status']
      expected = 200
      it "has a 200 status" do
        expect(value).to eql(expected)
      end
    end

    # context "given a redirect with special encoding" do
    #   link = 'https://autohotkey.com/board/topic/94376-'
    #   r = AwesomeBot::check link
    #   s = r.status[0]
    #   value = s['headers']['location']
    #   expected = '//autohotkey.com/board/topic/94376-socket-class-überarbeitet/'
    #   it "is encoded using utf8" do
    #     expect(value).to eql(expected)
    #   end
    # end

    context "given an incomplete redirect" do
      link = 'https://godoc.org/github.com/ipfs/go-libp2p-crypto'
      r = AwesomeBot::check link
      s = r.status[0]
      value = s['headers']['location']
      expected = 'https://godoc.org/github.com/libp2p/go-libp2p-crypto'
      it "the redirect is adjusted" do
        expect(value).to eql(expected)
      end
    end

    context "given links with basic authentication" do
      content = %(
        http://user:passwd@httpbin.org/basic-auth/user/passwd
        http://user:badpasswd@httpbin.org/basic-auth/user/passwd
      )
      r = AwesomeBot::check content

      it "good password has no issues" do
        expect(r.status[0]['status']).to eql(200)
      end

      it "bad password has issue" do
        expect(r.status[1]['status']).to eql(401)
      end
    end

  end
end
