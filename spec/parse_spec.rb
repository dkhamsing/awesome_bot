require 'awesome_bot'

describe AwesomeBot do
  describe "check" do
    context "given adoc link" do
      content = 'https://www.linkedin.com/topic/group/kotlin-developers?gid=7417237[LinkedIn: Kotlin Developers (Join!)^]'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'https://www.linkedin.com/topic/group/kotlin-developers?gid=7417237'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context "given markdown input" do
      content = "[Eddystone](https://en.wikipedia.org/wiki/Eddystone_(Google))"\
      "her [dockerfiles](https://github.com/jfrazelle/dockerfiles))"\
      "# ng-flow [![Build Status](https://travis-ci.org/flowjs/ng-flow.svg)](https://travis-ci.org/flowjs/ng-flow) [![Coverage Status](https://coveralls.io/repos/flowjs/ng-flow/badge.svg?branch=master&service=github)](https://coveralls.io/github/flowjs/ng-flow?branch=master)      "
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      expected = 5
      value = f.count
      it "has 5 links" do
        expect(value).to eql(expected)
      end
    end

    context "given a link with a comma" do
      content = %(
      #### JavaScript [Ecma International/TC39]
      - [ECMAScript 1 (PDF)](http://www.ecma-international.org/publications/files/ECMA-ST-ARCH/ECMA-262,%201st%20edition,%20June%201997.pdf) [Standard ECMA-262, 1st Edition June 1997]
      )
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'http://www.ecma-international.org/publications/files/ECMA-ST-ARCH/ECMA-262%2c%201st%20edition%2c%20June%201997.pdf'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end
  end
end
