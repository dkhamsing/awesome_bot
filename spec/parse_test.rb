require 'awesome_bot'

describe AwesomeBot do
  describe "check" do
    context "given markdown input" do
      content = "[Eddystone](https://en.wikipedia.org/wiki/Eddystone_(Google))"\
      "her [dockerfiles](https://github.com/jfrazelle/dockerfiles))"\
      "# ng-flow [![Build Status](https://travis-ci.org/flowjs/ng-flow.svg)](https://travis-ci.org/flowjs/ng-flow) [![Coverage Status](https://coveralls.io/repos/flowjs/ng-flow/badge.svg?branch=master&service=github)](https://coveralls.io/github/flowjs/ng-flow?branch=master)      "

      r = AwesomeBot::check content

      expected = 5
      value = r['status'].count
      it "has 5 links" do
        expect(value).to eql(expected)
      end
    end
  end
end
