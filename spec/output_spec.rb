require 'awesome_bot'

describe AwesomeBot do
  describe "output" do
    content = %(1 hi
    2 yo
    3 http://google.com
    3 http://yahoo.com
    )

    context "given url in content" do
      url = 'http://google.com'
      value = AwesomeBot::loc url, content
      expected = 3
      it "finds the line number" do
        expect(value).to eql(expected)
      end
    end

    context "given content" do
      url = 'http://google.com'
      value = AwesomeBot::number_of_digits content
      expected = 1
      it "finds the number of digits" do
        expect(value).to eql(expected)
      end
    end

    context "given status code 200" do
      code = 200
      value = AwesomeBot::log_status code
      expected = AwesomeBot::STATUS_OK
      it "returns the symbol for status ok" do
        expect(value).to eql(expected)
      end
    end

    context "given status code 301" do
      code = 301
      value = AwesomeBot::log_status code
      expected = AwesomeBot::STATUS_REDIRECT
      it "returns the symbol for status redirect" do
        expect(value).to eql(expected)
      end
    end

    context "given status code 404" do
      code = 404
      value = AwesomeBot::log_status code
      expected = AwesomeBot::STATUS_400s
      it "returns the 400 status symbol" do
        expect(value).to eql(expected)
      end
    end

    context "given status code 202" do
      code = 202
      value = AwesomeBot::log_status code
      expected = AwesomeBot::STATUS_OTHER
      it "returns the 'other' status symbol" do
        expect(value).to eql(expected)
      end
    end

    context "given unordered hashes" do
      hash1 = {'url'=>'http://yahoo.com'}
      hash2 = {'url'=>'http://google.com'}
      hashes = [hash1, hash2]
      o = AwesomeBot::order_by_loc hashes, content
      value = o.first['url']
      expected = 'http://google.com'
      it "orders them" do
        expect(value).to eql(expected)
      end
    end

    context "given a result hash" do
      url = 'url'
      hash = {
        'url'=>url,
        'loc'=>0,
        'status'=>200
      }
      index = 10
      value, _ = AwesomeBot::output(hash, index, 1, 1)
      expected = url
      it "should display the url" do
        expect(value).to include(expected)
      end

      it "should display the line of link" do
        expect(value).to include('[L')
      end

      it "should display the index" do
        indexplus = (index + 1).to_s
        expect(value).to include(indexplus)
      end
    end

    context "given a result hash with error status" do
      error = 'error'
      hash = {
        'status'=>AwesomeBot::STATUS_ERROR,
        'loc'=>0,
        'error'=>error
      }
      value, _ = AwesomeBot::output(hash, 1, 1, 1)
      expected = AwesomeBot::STATUS_ERROR.to_s
      it "should not display the status" do
        expect(value).not_to include(expected)
      end

      it "should display the error" do
        expect(value).to include(error)
      end
    end

    context "given a result hash with a redirect status" do
      status = 301
      hash = {
        'status'=>status,
        'loc'=>0,
        'headers'=>{'location'=>'redirect'}
      }
      value, _ = AwesomeBot::output(hash, 1, 1, 1)
      expected = status.to_s
      it "should display the status" do
        expect(value).to include(expected)
      end
    end

    context "given a redirect result hash" do
      redirect = 'redirect'
      hash = {
        'status'=>301,
        'headers'=>{'location'=>redirect}
      }
      value, _ = AwesomeBot::output_redirect hash
      expected = " #{AwesomeBot::STATUS_REDIRECT} #{redirect}"
      it "outputs a redirect" do
        expect(value).to eql(expected)
      end
    end

    context "given a non-redirect result hash" do
      redirect = 'redirect'
      hash = {
        'status'=>200
      }
      value, _ = AwesomeBot::output_redirect hash
      expected = ''
      it "outputs nothing" do
        expect(value).to eql(expected)
      end
    end

    context "given a list" do
      list = [1,2]
      value = AwesomeBot::pad_list list
      expected = 1
      it "finds the right pad" do
        expect(value).to eql(expected)
      end
    end

    # TODO: pad_text
  end
end
