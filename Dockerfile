FROM ruby:3.2.2-alpine

# Install  docker/buildx-bin
COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# Set the working directory to /luo
WORKDIR /luo

# Copy the Gemfile, Gemfile.lock into the container
COPY Gemfile Gemfile.lock luo.gemspec ./

# Required in luo.gemspec
COPY lib/luo/version.rb /luo/lib/luo/version.rb

# Install system dependencies
RUN apk add --no-cache --update build-base git docker openrc openssh-client-default \
    && rc-update add docker boot \
    && gem install bundler --version=2.4.3 \
    && bundle install

# Copy the rest of our application code into the container.
# We do this after bundle install, to avoid having to run bundle
# everytime we do small fixes in the source code.
COPY . .

# Install the gem locally from the project folder
RUN gem build luo.gemspec && \
    gem install ./luo-*.gem --no-document

RUN git config --global --add safe.directory /workdir

WORKDIR /workdir

ENTRYPOINT ["luo"]