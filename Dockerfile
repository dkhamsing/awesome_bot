FROM ruby

RUN gem install awesome_bot --no-format-exec

WORKDIR /tmp

ENTRYPOINT ["awesome_bot"]
CMD ["--help"]
