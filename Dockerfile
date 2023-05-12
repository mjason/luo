FROM ruby:3.2.2

# Install  docker/buildx-bin
#COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# Set the working directory to /luo
WORKDIR /luo

# Copy the Gemfile, Gemfile.lock into the container
COPY Gemfile Gemfile.lock luo.gemspec ./

# Required in luo.gemspec
COPY lib/luo/version.rb /luo/lib/luo/version.rb

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && gem install bundler --version=2.4.6 \
    && bundle install

## install python and jupyterlab
# Install Python and JupyterLab
RUN apt-get install -y --no-install-recommends \
     python3 python3-pip python3-dev  && \
     pip3 install --no-cache-dir jupyterlab && \
     pip3 install jupyterlab-language-pack-zh-CN

RUN gem install pry
RUN gem install iruby
RUN iruby register --force

# Expose the JupyterLab port
EXPOSE 8888

# Copy the rest of our application code into the container.
# We do this after bundle install, to avoid having to run bundle
# everytime we do small fixes in the source code.
COPY . .

# Install the gem locally from the project folder
RUN gem build luo.gemspec && \
    gem install ./luo-*.gem --no-document

WORKDIR /workdir
RUN rm -rf /luo

ENTRYPOINT ["luo"]