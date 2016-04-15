require 'awesome_bot'

describe AwesomeBot do
  describe "check" do
    context "given adoc link" do
      content = 'https://www.linkedin.com/topic/group/kotlin-developers?gid=7417237[LinkedIn: Kotlin Developers (Join!)^]'
      content = GitHub::Markup.render('README.adoc', content)
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
      content = GitHub::Markup.render('README.md', content)
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      expected = 6
      value = f.count
      it "has 6 links" do
        expect(value).to eql(expected)
      end
    end
  end
end
