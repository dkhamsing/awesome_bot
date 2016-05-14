require 'awesome_bot'

describe AwesomeBot do
  describe "cli" do
    options = {}
    file = 'bin/assets/test-redirect'

    context "given a file with a redirect" do
      value = AwesomeBot.cli_process file, options
      expected = 'Issues'
      it "finds issues" do
        expect(value).to eql(expected)
      end
    end

    context "given  file with a redirect and allowing redirects" do
      options['allow_redirect'] = true
      value = AwesomeBot.cli_process file, options
      expected = '✓'
      it "finds no issues" do
        expect(value).to eql(expected)
      end
    end
  end
end
