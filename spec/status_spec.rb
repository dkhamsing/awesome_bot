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
      r = AwesomeBot::check 'http://www.rubydoc.info/gems/awesome_bot other'
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

    context "given a redirect with special ecoding" do
      link = 'https://autohotkey.com/board/topic/94376-'
      r = AwesomeBot::check link
      s = r.status[0]
      value = s['headers']['location']
      expected = '//autohotkey.com/board/topic/94376-socket-class-überarbeitet/'
      it "is encoded using utf8" do
        expect(value).to eql(expected)
      end
    end
  end
end
