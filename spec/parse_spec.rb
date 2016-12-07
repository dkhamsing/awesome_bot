require 'awesome_bot'

describe AwesomeBot do
  describe "parse" do
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

    context "given links spearated by comma" do
      content = 'https://github.com/dkhamsing, https://twitter.com/dkhamsing'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'https://github.com/dkhamsing'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context "given a link that ends with a period" do
      content = 'https://github.com/alloy/lowdown.'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'https://github.com/alloy/lowdown'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context 'given a link with a colon' do
      content = '[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html) [![PyPI](https://img.shields.io/pypi/pyversions/gitsome.svg)](https://pypi.python.org/pypi/gitsome/)'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'http://img.shields.io/:license-apache-blue.svg'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context 'given a link ending with colon' do
      content = 'for http://yahoo.com:'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'http://yahoo.com'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context 'given a wikipedia link with parentheses' do
      content = 'https://en.wikipedia.org/wiki/Counter_(digital)'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'https://en.wikipedia.org/wiki/Counter_(digital)'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context 'given a markdown wikipedia link' do
      content = '[TAL](https://en.wikipedia.org/wiki/Template_Attribute_Language)'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'https://en.wikipedia.org/wiki/Template_Attribute_Language'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context 'given a markdown wikipedia link with a period' do
      content = '[Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation).'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list
      value = f[0]
      expected = 'https://en.wikipedia.org/wiki/Hungarian_notation'
      it "parses correctly" do
        expect(value).to eql(expected)
      end
    end

    context 'given markdown wikipedia content' do
      content = 'Unlike [SOAP](https://en.wikipedia.org/wiki/SOAP)-based ...as [HTTP](https://en.wikipedia.org/wiki/HTTP), [URI](https://en.wikipedia.org/wiki/URI), [JSON](https://en.wikipedia.org/wiki/JSON), and [XML](https://en.wikipedia.org/wiki/XML). [[1](#references)]'
      list = AwesomeBot::links_find content
      f = AwesomeBot::links_filter list

      value = f[0]
      expected = 'https://en.wikipedia.org/wiki/SOAP'
      it "parses correctly" do
        expect(value).to eql(expected)
      end

      value = f[1]
      expected = 'https://en.wikipedia.org/wiki/HTTP'
      it "parses correctly" do
        expect(value).to eql(expected)
      end

    end

  end
end
