FROM ruby:3.2.2-alpine

# Install dependencies
RUN gem install luo

WORKDIR /workdir

ENTRYPOINT ["luo"]