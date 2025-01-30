FROM ruby:3.2.6

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client

# Install Rails 7
RUN gem install rails -v 7.1.5

# Set up a working directory
WORKDIR /workspace

CMD ["/bin/bash"]