FROM ruby:2.5.0-alpine
RUN \
  apk update && \
  apk add libffi-dev build-base
RUN mkdir -p /opt/coloRs
WORKDIR /opt/coloRs
ADD . ./
RUN bundle install
RUN rake colors[script]