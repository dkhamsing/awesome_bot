require 'awesome_bot'

describe AwesomeBot do
  describe "cli" do
    context "given no option" do
      opt = {}
      value = AwesomeBot.output_summary opt
      expected = ''
      it "will not output summary" do
        expect(value).to eql(expected)
      end
    end

    context "given markdown option" do
      opt = {'markdown'=> true}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_MARKDOWN
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given base_url option" do
      opt = {'base_url'=> 'test'}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_BASE
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given errors option" do
      opt = {AwesomeBot::CLI_OPT_ERRORS=> ['test']}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_ERRORS
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given allow_dupe option" do
      opt = {AwesomeBot::CLI_OPT_ALLOW_DUPE=> true}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_DUPE
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given allow_redirect option" do
      opt = {AwesomeBot::CLI_OPT_ALLOW_REDIRECT=> true}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_REDIRECT
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given allow_ssl option" do
      opt = {AwesomeBot::CLI_OPT_ALLOW_SSL=> true}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_SSL
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given allow_timeout option" do
      opt = {AwesomeBot::CLI_OPT_ALLOW_TIMEOUT=> true}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_TIMEOUT
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given delay option" do
      opt = {'delay'=> 1}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_DELAY
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given timeout option" do
      opt = {'timeout'=> 1}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_CONNECTION
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given white_list option" do
      opt = {'white_list'=> ['test']}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_WHITELIST
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    context "given no_results option" do
      opt = {'no_results'=> true}
      value = AwesomeBot.output_summary opt
      expected = AwesomeBot::OUTPUT_SUMMARY_SAVE
      it "will output summary" do
        expect(value).to include(expected)
      end
    end

    options = {}
    file = 'bin/assets/test-redirect'
    content = File.read file

    `rm *.json`
    context "given --skip-save-results option true" do
      options[AwesomeBot::CLI_OPT_ALLOW_REDIRECT] = true
      options['no_results'] = true
      AwesomeBot.cli_process file, options
      value = ''
      expected = `ls *.json`
      it "does not write results" do
        expect(value).to eql(expected)
      end
    end

    context "given --skip-save-results option true (api contract)" do
      option = true
      r = AwesomeBot.check content
      value = AwesomeBot.write_results file, r, option
      expected = false
      it "returns false" do
        expect(value).to eql(expected)
      end

      value = AwesomeBot.write_markdown_results file, nil, option
      expected = false
      it "returns false" do
        expect(value).to eql(expected)
      end

      value = AwesomeBot.write_results_filtered file, nil, option
      expected = nil
      it "returns nil" do
        expect(value).to eql(expected)
      end
    end

    context "given a file with a redirect" do
      options = {}
      value = AwesomeBot.cli_process file, options
      expected = 'Issues'
      it "finds issues" do
        expect(value).to eql(expected)
      end
    end

    context "given a file with a redirect and allowing redirects" do
      options[AwesomeBot::CLI_OPT_ALLOW_REDIRECT] = true
      value = AwesomeBot.cli_process file, options
      expected = '✓'
      it "finds no issues" do
        expect(value).to eql(expected)
      end
    end

    `rm *.json`
    context "given --skip-save-results option false" do
      options['no_results'] = false
      AwesomeBot.cli_process file, options
      value = `ls *.json`
      expected = 'json'
      it "does write results" do
        expect(value).to include(expected)
      end
    end

    context "give --skip-save-results option true (api contract)" do
      option = false
      r = AwesomeBot.check content
      value = AwesomeBot.write_results file, r, option
      expected = true
      it "returns true" do
        expect(value).to eql(expected)
      end

      value = AwesomeBot.write_markdown_results file, nil, option
      expected = true
      it "returns true" do
        expect(value).to eql(expected)
      end

      value = AwesomeBot.write_results_filtered file, [], option
      expected = 'ab-results-bin-assets-test-redirect-filtered.json'
      it "returns filtered results file" do
        expect(value).to eql(expected)
      end
    end
  end
end
