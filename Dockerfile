FROM ruby:alpine

RUN gem install awesome_bot --no-format-exec

VOLUME /mnt

WORKDIR /mnt

ENTRYPOINT ["awesome_bot"]
CMD ["--help"]
