
def repo(repo_url)
  repo_url.sub 'https://github.com/', ''
end

def circle_badge(repo_url)
  r = repo repo_url
  "[![Circle CI](https://img.shields.io/circleci/project/#{r}.svg)](https://circleci.com/gh/#{r})"
end

def circle_config(repo_url)
  config_url = "https://github.com/#{repo_url}/blob/master/circle.yml"
  "[`config`](#{config_url})"
end

def travis_badge(repo_url)
  r = repo repo_url
  "[![Build Status](https://travis-ci.org/#{r}.svg)](https://travis-ci.org/#{r})"
end

def travis_config(repo_url)
  config_url = "https://github.com/#{repo_url}/blob/master/.travis.yml"
  "[`config`](#{config_url})"
end

OUTPUT = 'status.md'

TRAVIS = 'list-travis-ci'
CIRCLE = 'list-circle-ci'

filename = TRAVIS
unless File.exist? filename
  puts "Could not open #{filename}"
  exit
end

c = File.read filename
r = c.split "\n"


filename2 = CIRCLE
unless File.exist? filename2
  puts "Could not open #{filename2}"
  exit
end

c2 = File.read filename2
r2 = c2.split "\n"

output = "# Awesome Status \n\n"
output << "Build status for **#{r.count + r2.count}** projects using https://github.com/dkhamsing/awesome_bot \n\n"
output << "Status | Config | Repo \n"
output << "---    | ---    | ---  \n"

r.each_with_index do |x, i|
  output << travis_badge(x)
  output << ' | '
  output << travis_config(x)
  output << ' | '
  output << "[#{repo(x)}](https://github.com/#{x})"
  output << " \n"
end

r2.each_with_index do |x, i|
  output << circle_badge(x)
  output << ' | '
  output << circle_config(x)
  output << ' | '
  output << "[#{repo(x)}](https://github.com/#{x})"
  output << " \n"
end

puts "Writing #{OUTPUT}"
File.write OUTPUT, output
puts '✅'
